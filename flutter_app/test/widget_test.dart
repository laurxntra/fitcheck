// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

// import 'package:flutter/material.dart';
// import 'package:flutter_app/pages/phone_login.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_app/pages/home_page.dart';
// import 'package:flutter_app/pages/otp_verification.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';


// void main() {
//   // test for homepage display
//    testWidgets('Homepage display is empty', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: HomePage()));
//       await tester.pumpAndSettle();
//       expect(find.text("No posts yet.\nTake a picture!"), findsOneWidget);
//   });

// // test for toggling between "Friends" and "My Post" on home page
//     testWidgets('Toggle feed between friends and my post', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(home: HomePage()));
//     await tester.pumpAndSettle();

//     expect(find.text('Friends'), findsOneWidget);
//     expect(find.text('My Post'), findsOneWidget);

//     await tester.tap(find.text('My Post'));
//     await tester.pumpAndSettle();

//     expect(find.text('Friends'), findsOneWidget);
//     expect(find.text('My Post'), findsOneWidget);
//     });

//   {
//     // test for otp verification
//     testWidgets('OTP input and button press', (WidgetTester tester) async {
//       await tester.pumpWidget(
//         MaterialApp(
//           home: OtpVerificationScreen(),
//           onGenerateRoute: (settings) {
//             return MaterialPageRoute(
//               settings: RouteSettings(arguments: {'phoneNumber': '123-456-7890'}),
//               builder: (_) => OtpVerificationScreen(),
//             );
//           },
//           routes: {
//             '/home': (context) => Scaffold(body: Center(child: Text('Home Screen'))),
//           },
//         ),
//       );

//         await tester.pumpAndSettle();

//       // Enter OTP.
//         await tester.enterText(find.byType(TextField), '123456');
//         await tester.pump();

//       // Press the "Verify & Continue" button.
//         await tester.tap(find.text('Verify & Continue'));
//         await tester.pumpAndSettle();

//       // Verify navigation to the home screen.
//         expect(find.text('Home Screen'), findsOneWidget);
//     });

//     testWidgets('Validates phone number and enables button', (WidgetTester tester) async {
//       await tester.pumpWidget(MaterialApp(home: PhoneLoginScreen()));

//       await tester.pumpAndSettle();

//       // Enter a valid phone number.
//       await tester.enterText(find.byType(IntlPhoneField), '1234567890');
//       await tester.pump();

//       // Verify that the "Send Verification Code" button is enabled.
//       expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled, isTrue);
//     });
//   }
// }
