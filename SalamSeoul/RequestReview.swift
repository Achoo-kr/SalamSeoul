//
//  RequestReview.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/06/09.
//

import SwiftUI
import StoreKit

struct ReviewCounter: ViewModifier {
    @AppStorage("reviewCounter") private var reviewCounter = 0

    func body(content: Content) -> some View {
        content
            .onAppear {
                reviewCounter += 1
                print("reviewCounter", reviewCounter)
            }
            .onDisappear {
                if reviewCounter > 3 {
                    reviewCounter = 0
                    DispatchQueue.main.async {
                        if let scene = UIApplication.shared.connectedScenes
                                .first(where: { $0.activationState == .foregroundActive })
                                as? UIWindowScene {
                            SKStoreReviewController.requestReview(in: scene)
                        }
                    }
                }
            }
    }
}

extension View {
    func reviewCounter() -> some View {
        modifier(ReviewCounter())
    }
}
