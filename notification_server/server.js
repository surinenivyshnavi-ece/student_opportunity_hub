const express = require("express");
const cors = require("cors");
const admin = require("firebase-admin");

console.log("FIREBASE_SERVICE_ACCOUNT exists:", !!process.env.FIREBASE_SERVICE_ACCOUNT);
console.log("Admin object:", admin);

const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const app = express();

app.use(cors());
app.use(express.json());

app.post("/sendNotification", async (req, res) => {
  try {
    const { title, body } = req.body;

    const message = {
      notification: {
        title: title,
        body: body,
      },
      topic: "allUsers",
    };

    await admin.messaging().send(message);

    res.json({
      success: true,
      message: "Notification sent successfully",
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      error: error.message,
    });
  }
});

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});