const functions = require("firebase-functions");
const admin = require("firebase-admin");
const {onSchedule} = require("firebase-functions/v2/scheduler");

// Initialize Firebase Admin SDK
admin.initializeApp();

/**
 * @param {string} title - The title of the notification
 * @param {string} body - The body of the notification
 * @return {Promise} - A promise that resolves when the notification is sent
 */
async function sendNotificationToAllUsers(title, body) {
  const firestore = admin.firestore();
  const usersSnapshot = await firestore.collection("users").get();
  const tokens = [];

  usersSnapshot.forEach((doc) => {
    const data = doc.data();
    if (data.deviceToken) {
      tokens.push(data.deviceToken);
    }
  });

  if (tokens.length > 0) {
    const payload = {
      notification: {
        title: title,
        body: body,
        sound: "default", // Adds default sound to the notification
      },
      android: {
        notification: {
          color: "#FFFFFF", // Set notification color
          icon: "assets/images/applogo.png", // Replace with your icon name
          priority: "high", // High priority for immediate delivery
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default", // Adds default sound to iOS notifications
          },
        },
      },
    };
    return admin.messaging().sendToDevice(tokens, payload);
  } else {
    functions.logger.info("No device tokens found.");
    return Promise.resolve();
  }
}

/**
 * Friday Night Notification (Scheduled at 8:00 PM every Friday)
 */
exports.fridayNightReminder = onSchedule("0 20 * * 5", async (event) => {
  functions.logger.info("Sending Friday Night Notification");
  await sendNotificationToAllUsers(
      "Reminder: Data Transfer",
      "Your data will be transferred soon.",
  );
});

/**
 * Sunday Morning Notification (Scheduled at 8:00 AM every Sunday)
 */
exports.sundayMorningNotification = onSchedule("0 8 * * 0", async (event) => {
  functions.logger.info("Sending Sunday Morning Notification");
  await sendNotificationToAllUsers(
      "Data Transferred",
      "Your data has been transferred to history.",
  );
});

/**
 * Monday Morning Data Transfer (Scheduled at 8:00 AM every Monday)
 */
exports.mondayMorningTransfer = onSchedule("0 8 * * 1", async (event) => {
  functions.logger.info("Transferring Data and Sending Notification");

  const uid = await getUserUID();

  // Call the data transfer function here
  await transferAndDeleteWeeklyData(uid);

  // Send a notification after the transfer
  await sendNotificationToAllUsers(
      "Data Transferred",
      "Your data has been transferred to history.",
  );
});

/**
 * @param {string} uid - The UID of the user whose data is being transferred.
 * @return {Promise<void>}
 */
async function transferAndDeleteWeeklyData(uid) {
  functions.logger.info("Starting data transfer and deletion.");

  try {
    const firestore = admin.firestore();

    if (uid) {
      const userDocRef = firestore.collection("users").doc(uid);

      // Calculate the start and end dates of the current week
      const now = new Date();
      const startOfWeek = new Date(
          now.setDate(now.getDate() - now.getDay() + 1),
      ); // Monday as start
      const endOfWeek = new Date(now.setDate(now.getDate() - now.getDay() + 7));
      functions.logger.info(`Start of Week: ${startOfWeek}`);
      functions.logger.info(`End of Week: ${endOfWeek}`);

      const calculatedValuesSnapshot = await userDocRef
          .collection("calculatedValues")
          .where("timestamp", ">=", startOfWeek)
          .where("timestamp", "<=", endOfWeek)
          .get();

      // Query the mileage fee collection
      const mileageFeeSnapshot = await userDocRef
          .collection("perMileageCost")
          .get();
      // Query the truck payment collection
      const truckPaymentSnapshot = await userDocRef
          .collection("truckPaymentCollection")
          .get();

      // Prepare data to be transferred
      const combinedData = {
        calculatedValues: [],
        mileageFee: [],
        truckPayment: [],
        transferTimestamp: new Date().toISOString(),
      };

      // Add calculated values data
      calculatedValuesSnapshot.forEach(async (doc) => {
        combinedData.calculatedValues.push(doc.data());
        try {
          await doc.ref.delete();
          functions.logger.info(`Document ${doc.id} deleted successfully.`);
        } catch (e) {
          functions.logger.error(`Error deleting document ${doc.id}: ${e}`);
        }
      });

      // Add mileage fee data without deleting
      mileageFeeSnapshot.forEach((doc) => {
        combinedData.mileageFee.push(doc.data());
      });

      // Add truck payment data without deleting
      truckPaymentSnapshot.forEach((doc) => {
        combinedData.truckPayment.push(doc.data());
      });

      // Set a new document in the history collection with a unique ID
      const historyDocId = firestore.collection("users").doc().id;
      const newHistoryDoc = userDocRef.collection("history").doc(historyDocId);
      await newHistoryDoc.set(combinedData);

      functions.logger.info("Data transferred and deleted successfully.");
    } else {
      functions.logger.error("No user UID provided.");
    }
  } catch (e) {
    functions.logger.error(`Error in transferAndDeleteWeeklyData: ${e}`);
  }
}

/**
 * Function to get the UID of the user.
 * You can replace this with your method of retrieving the user UID.
 * @return {Promise<string>} The UID of the user.
 */
async function getUserUID() {
  try {
    // Example: Retrieving a specific user's UID based on a phone number
    const user = await admin.auth().getUserByPhoneNumber("+12624216834");
    return user.uid;
  } catch (e) {
    functions.logger.error(`Error retrieving user UID: ${e}`);
    return null;
  }
}
