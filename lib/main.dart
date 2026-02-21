import 'package:eekcchutkimein_delivery/app.dart';
import 'package:eekcchutkimein_delivery/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }

  // TODO: Register with FCM
  String? token = await messaging.getToken();

  if (kDebugMode) {
    print('Registration Token=$token');
  }

  // TODO: Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // TODO: Subscribe to a topic
  await GetStorage.init();
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
}

// private static void sendMessageToFcmRegistrationToken() throws Exception {
//    String registrationToken = "REPLACE_WITH_FCM_REGISTRATION_TOKEN";
//    Message message =
//        Message.builder()
//            .putData("FCM", "https://firebase.google.com/docs/cloud-messaging")
//            .putData("flutter", "https://flutter.dev/")
//            .setNotification(
//                Notification.builder()
//                    .setTitle("Try this new app")
//                    .setBody("Learn how FCM works with Flutter")
//                    .build())
//            .setToken(registrationToken)
//            .build();

//    FirebaseMessaging.getInstance().send(message);

//    System.out.println("Message to FCM Registration Token sent successfully!!");
//  }
