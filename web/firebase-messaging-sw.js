importScripts('https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.6.1/firebase-messaging.js');

// Firebase initialization
firebase.initializeApp({
  apiKey: "AIzaSyCeEq4VVlDp8plMO3LSGkQhHtxiEg4ONTg",
  authDomain: "wander-crew.firebaseapp.com",
  projectId: "wander-crew",
  storageBucket: "wander-crew.appspot.com",
  messagingSenderId: "383803428115",
  appId: "1:383803428115:web:1432274364075cdb1a9ee6",
  measurementId: "G-SCNPB2JYB5",
});

//importScripts('/firebase-app.js');
//importScripts('https://www.gstatic.com/firebasejs/9.22.2/firebase-messaging.js');
//// Initialize Firebase Messaging
const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    // icon: '/firebase-logo.png'  // If you have an icon, add it here
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
