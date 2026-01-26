# Flutter rules are compiled into the base Flutter Gradle script. See
# https://flutter.dev/docs/deployment/android#reviewing-the-gradle-build-configuration.
-dontwarn io.flutter.embedding.android.FlutterFragment
-dontwarn io.flutter.embedding.android.FlutterView
-dontwarn io.flutter.embedding.android.FlutterActivity

# Rules for Stripe SDK
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
