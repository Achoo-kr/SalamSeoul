//
//  SalamSeoulApp.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/21.
//

import SwiftUI
import FirebaseCore
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct SalamSeoulApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var entitlementManager: EntitlementManager
    @StateObject private var purchaseManager: PurchaseManager
    
    init() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)
        
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }

    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(entitlementManager)
                .environmentObject(purchaseManager)
                .task {
                    await purchaseManager.updatePurchasedProducts()
                }
        }
    }
}
