//
//  StoreKitManager.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/06/09.
//

import SwiftUI

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.your.app")!

    @AppStorage("isPro", store: userDefaults)
    var hasPro: Bool = false
}
