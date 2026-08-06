import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../core/config/app_config.dart';

/// Wraps the RevenueCat SDK. Call [configure] once at app startup when
/// [AppConfig.isRevenueCatConfigured] is true; the paywall screen falls
/// back to a dev-preview flow otherwise.
class PurchasesService {
  bool get isConfigured => AppConfig.isRevenueCatConfigured;

  Future<void> configure({required String appUserId}) async {
    if (!isConfigured) return;
    await Purchases.configure(
      PurchasesConfiguration(AppConfig.revenueCatApiKey)..appUserID = appUserId,
    );
  }

  Future<Offerings> fetchOfferings() {
    return Purchases.getOfferings();
  }

  Future<CustomerInfo> purchasePackage(Package package) async {
    final result = await Purchases.purchase(PurchaseParams.package(package));
    return result.customerInfo;
  }
}
