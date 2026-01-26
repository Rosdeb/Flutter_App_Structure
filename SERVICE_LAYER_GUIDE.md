📦 Code_Structure App – Service Layer Documentation
Overview

This document provides a comprehensive guide to the Service Layer of the Pagedrop application.
The service layer is responsible for all external integrations, including:

API communication

Authentication

Payments (Stripe & Apple IAP)

Notifications (Firebase)

It acts as the single source of truth for all network and platform services.

🏗 Service Architecture

The service layer is organized into the following domains:

lib/
└── Service/
├── Auth/
├── Stripe/
├── IPA/
├── Apple/
└── FirebaseNotifications/

1️⃣ Authentication Services (/Auth)

Handles user authentication, token lifecycle, and secure API communication.

Components
Service	Responsibility
ApiService	HTTP wrapper with token handling
AuthService	Token refresh & validation
GoogleSignInService	Google authentication
AppleSignInService	Apple Sign-In
🔹 ApiService – Features

GET, POST, PUT, DELETE, PATCH

Automatic token injection

Token refresh on 401 Unauthorized

Network connectivity validation

Multipart form data support

Centralized error handling & logging

Usage Example
import 'package:pagedrop/Service/Auth/Api_Services.dart';

// GET request
final profile = await ApiService().get(
endpoint: '/users/profile',
);

// POST request with authentication
final response = await ApiService().post(
endpoint: '/users/update',
body: {'name': 'John Doe'},
requiresAuth: true,
);

// POST request without authentication
final login = await ApiService().post(
endpoint: '/auth/login',
body: {
'email': 'user@example.com',
'password': 'password',
},
requiresAuth: false,
);

2️⃣ Payment Services

Handles all monetization flows including Stripe payments and Apple In-App Purchases.

🔹 Stripe Service (/stripe)
Features

Secure Stripe Payment Sheet

Payment confirmation

Error & cancellation handling

Usage Example
import 'package:pagedrop/Service/stripe/stripe_service.dart';

final paymentResponse = await StripeService.instance.makePayment(
amount: 9.99,
currency: 'usd',
);

switch (paymentResponse.result) {
case PaymentResult.success:
// Payment successful
break;
case PaymentResult.canceled:
// User canceled
break;
case PaymentResult.failed:
// Payment failed
break;
}

🔹 Apple In-App Purchase Service (/IPA)

Used for iOS subscriptions and in-app purchases.

Features

Product loading

Subscription purchase

Restore purchases

Purchase callbacks

Usage Example
import 'package:pagedrop/Service/IPA/IPA_services.dart';

final iapService = AppleIAPService.instance;

// Initialize
await iapService.initialize();

// Callbacks
iapService.onPurchaseSuccess = (purchaseDetails) {
// Handle success
};

iapService.onPurchaseError = (purchaseDetails) {
// Handle error
};

// Load products
await iapService.loadProducts();

// Purchase subscription
await iapService.purchaseSubscription(
'com.pagedrop.lagier.monthly.subscription',
);

3️⃣ Social Authentication
🔹 Google Sign-In

Firebase-based Google authentication

Retrieves user profile & email

import 'package:pagedrop/Service/Auth/gogle_sign.dart';

final userData = await GoogleSignInService.signInWithGoogle();

if (userData != null) {
final user = userData['user'];
final email = userData['email'];
}

🔹 Apple Sign-In

Secure Apple authentication

Handles name & email privacy

Token validation

import 'package:pagedrop/Service/apple/AppleSignInService.dart';

final userData = await AppleSignInService.signInWithApple();

if (userData != null) {
final email = userData['email'];
final displayName = userData['displayName'];
}

4️⃣ Notification Services (/FirebaseNotifications)

Handles push notifications across iOS & Android.

🔹 NotificationService – Features

Firebase Cloud Messaging (FCM)

Local notifications

Permission handling

Topic subscription

Enable/disable notifications

Usage Example
import 'package:pagedrop/Service/FirebaseNotifications/notificationService.dart';

// Initialize
await NotificationService.initialize();

// Get FCM token
await NotificationService.getFcmToken();

// Enable / Disable notifications
await NotificationService.toggleNotifications(true);

// Check status
final isEnabled =
await NotificationService.getNotificationPreference();

🧠 Common Design Patterns
Singleton Pattern
class MyService {
static final MyService _instance = MyService._internal();

factory MyService() => _instance;

MyService._internal();

// Service methods
}

Callback Pattern
Function(PurchaseDetails)? onPurchaseSuccess;
Function(PurchaseDetails)? onPurchaseError;

Result Pattern
class PaymentResponse {
final PaymentResult result;
final String? paymentIntentId;

PaymentResponse(
this.result, {
this.paymentIntentId,
});
}

🔌 Integration with GetX
Controller Example
class UserController extends GetxController {
Future<void> login(String email, String password) async {
try {
final result = await ApiService().post(
endpoint: '/auth/login',
body: {
'email': email,
'password': password,
},
requiresAuth: false,
);
} catch (e) {
// Handle error
}
}
}

⚙ Environment Configuration

Ensure .env contains:

APP_NAME=Pagedrop
BASE_URL=https://api.example.com

STRIPE_PUBLIC_KEY=pk_test_xxx
STRIPE_SECRET_KEY=sk_test_xxx

✅ Best Practices
Security

Never expose secret keys

Always validate tokens

Use HTTPS only

Performance

Cache frequently used data

Paginate large responses

Optimize image loading

Testing

Mock services

Use dependency injection

Write integration tests for payments & auth

🧪 Troubleshooting
Issue	Solution
Token refresh fails	Verify refresh endpoint
Stripe errors	Check environment keys
IAP not working	Validate product IDs
Notifications missing	Check permissions