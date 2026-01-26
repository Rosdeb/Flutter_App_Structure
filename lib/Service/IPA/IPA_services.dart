import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:pagedrop/utils/Logger/logger.dart';

class AppleIAPService {
  static final AppleIAPService instance = AppleIAPService._internal();
  factory AppleIAPService() => instance;
  AppleIAPService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];

  // ⚠️ IMPORTANT: Replace these with your actual product IDs from App Store Connect
  // Format: com.yourcompany.yourapp.monthly
  static const String monthlySubscriptionId = 'com.pagedrop.lagier.monthly.subscription';
  static const String yearlySubscriptionId = 'com.pagedrop.lagier.yearly.subscription';

  static const Set<String> _productIds = {
    monthlySubscriptionId,
    yearlySubscriptionId,
  };

  // Callbacks
  Function(PurchaseDetails)? onPurchaseSuccess;
  Function(PurchaseDetails)? onPurchaseError;
  Function(PurchaseDetails)? onPurchaseCanceled;
  Function()? onPurchaseRestored;

  ///-----> Initialize IAP <-------//
  Future<bool> initialize() async {
    try {
      _isAvailable = await _iap.isAvailable();

      if (!_isAvailable) {
        print('❌ In-App Purchase not available');
        return false;
      }

      print('✅ IAP is available');

      // Enable pending purchases for iOS
      if (Platform.isIOS) {
        final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
        _iap.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
        await iosPlatformAddition.setDelegate(PaymentQueueDelegate());
      }

      // Listen to purchase stream
      _subscription = _iap.purchaseStream.listen(
        _handlePurchaseUpdates,
        onDone: () => _subscription.cancel(),
        onError: (error) => print('❌ Purchase Stream Error: $error'),
      );

      // Load products
      await loadProducts();

      return true;
    } catch (e) {
      print('❌ Initialize error: $e');
      return false;
    }
  }

  /// Load products from App Store
  Future<bool> loadProducts() async {
    if (!_isAvailable) {
      print('❌ IAP not available');
      return false;
    }

    try {
      _products.clear();
      final ProductDetailsResponse response = await _iap.queryProductDetails(_productIds);

      if (response.notFoundIDs.isNotEmpty) {
        print('⚠️ Products not found: ${response.notFoundIDs}');
        print('⚠️ Make sure these product IDs exist in App Store Connect');
      }

      if (response.error != null) {
        print('❌ Error loading products: ${response.error}');
        return false;
      }

      _products = response.productDetails;
      print('✅ Loaded ${_products.length} products');

      for (var product in _products) {
        print('📦 Product: ${product.id}');
        print('   Title: ${product.title}');
        print('   Price: ${product.price}');
        print('   Description: ${product.description}');
      }

      return _products.isNotEmpty;
    } catch (e) {
      print('❌ Exception loading products: $e');
      return false;
    }
  }

  /// Get all products
  List<ProductDetails> get products => _products;

  /// Get product by ID
  ProductDetails? getProductById(String productId) {
    try {
      return _products.firstWhere((product) => product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Get products (async method for loading if needed)
  Future<List<ProductDetails>> getProducts() async {
    if (_products.isEmpty) {
      await loadProducts();
    }
    return _products;
  }
  /// Purchase subscription
  ///
  /// [productId] The unique identifier of the product to purchase
  ///
  /// Returns true if the purchase was successfully initiated, false otherwise
  Future<bool> purchaseSubscription(String productId) async {
    if (!_isAvailable) {
      Logger.log('❌ IAP not available', type: 'error');
      return false;
    }

    final product = getProductById(productId);
    if (product == null) {
      Logger.log('❌ Product not found: $productId', type: 'error');
      return false;
    }

    try {
      Logger.log('🛒 Initiating purchase for: $productId', type: 'info');

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      // Use buyNonConsumable for subscriptions
      final bool success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);

      Logger.log(success ? '✅ Purchase initiated' : '❌ Failed to initiate purchase', type: 'info');
      return success;
    } catch (e) {
      Logger.log('❌ Purchase exception: $e', type: 'error');
      return false;
    }
  }

  /// Purchase consumable product
  ///
  /// [productId] The unique identifier of the product to purchase
  ///
  /// Returns true if the purchase was successfully initiated, false otherwise
  Future<bool> purchaseConsumable(String productId) async {
    if (!_isAvailable) {
      Logger.log('❌ IAP not available', type: 'error');
      return false;
    }

    final product = getProductById(productId);
    if (product == null) {
      Logger.log('❌ Product not found: $productId', type: 'error');
      return false;
    }

    try {
      Logger.log('🛒 Initiating consumable purchase for: $productId', type: 'info');

      final PurchaseParam purchaseParam = PurchaseParam(
        productDetails: product,
      );

      final bool success = await _iap.buyConsumable(purchaseParam: purchaseParam);

      Logger.log(success ? '✅ Consumable purchase initiated' : '❌ Failed to initiate consumable purchase', type: 'info');
      return success;
    } catch (e) {
      Logger.log('❌ Consumable purchase exception: $e', type: 'error');
      return false;
    }
  }

  /// Handle purchase updates
  /// Handle purchase updates
  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      print('📦 Purchase Update - Status: ${purchaseDetails.status}');
      print('📦 Product ID: ${purchaseDetails.productID}');

      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print('⏳ Purchase pending...');
          break;

        case PurchaseStatus.purchased:
          print('✅ Purchase successful!');
          // ✅ Call success callback for NEW purchase
          if (onPurchaseSuccess != null) {
            onPurchaseSuccess!(purchaseDetails);
          }
          break;

        case PurchaseStatus.restored:
          print('♻️ Purchase restored!');
          // ✅ IMPORTANT: Restored purchases ALSO go through onPurchaseSuccess
          // The controller will determine if it's a restore based on the status
          if (onPurchaseSuccess != null) {
            onPurchaseSuccess!(purchaseDetails);
          }
          // ✅ Also trigger restore callback for UI feedback
          if (onPurchaseRestored != null) {
            onPurchaseRestored!();
          }
          break;

        case PurchaseStatus.error:
          print('❌ Purchase error: ${purchaseDetails.error}');
          if (onPurchaseError != null) {
            onPurchaseError!(purchaseDetails);
          }
          break;

        case PurchaseStatus.canceled:
          print('🚫 Purchase canceled');
          if (onPurchaseCanceled != null) {
            onPurchaseCanceled!(purchaseDetails);
          }
          break;
      }

      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        _iap.completePurchase(purchaseDetails);
      }
    }
  }
  /// Verify and deliver product
  Future<void> _verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      print('🔍 Verifying purchase...');

      // Call success callback
      if (onPurchaseSuccess != null) {
        onPurchaseSuccess!(purchaseDetails);
      }
    } catch (e) {
      print('❌ Error verifying purchase: $e');
    }
  }

  /// Restore purchases
  Future<void> restorePurchases() async {
    if (!_isAvailable) {
      print('❌ IAP not available');
      return;
    }

    try {
      print('♻️ Restoring purchases...');
      await _iap.restorePurchases();
    } catch (e) {
      print('❌ Restore purchases error: $e');
      rethrow;
    }
  }

  /// Check if IAP is available
  bool get isAvailable => _isAvailable;

  /// Dispose
  void dispose() {
    _subscription.cancel();
  }

  /// Check if a specific product is subscribed
  /// This is a simplified check - in production, you should verify with your backend
  bool isSubscribed(String productId) {
    // In a real app, you would check this against your backend or local receipt validation
    // This is just a placeholder implementation
    return true; // Placeholder - implement actual subscription check
  }

  /// Get subscription expiration date for a product
  /// This is a simplified method - in production, you should verify with your backend
  DateTime? getSubscriptionExpirationDate(String productId) {
    // In a real app, you would parse the receipt to get the actual expiration date
    // This is just a placeholder implementation
    return null; // Placeholder - implement actual expiration date check
  }
}

/// Payment Queue Delegate
class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}