//
//  RestaurantMainFeatureTest.swift
//  RestaurantMainFeatureTest
//
//  Created by 추현호 on 2023/05/08.
//

import XCTest
import ComposableArchitecture
@testable import SalamSeoul

final class RestaurantMainFeatureTest: XCTestCase {
    //https://www.pointfree.co/episodes/ep195-async-composable-architecture-the-problem
//    func testObserveSuccess() {
//        let store = TestStore(
//            initialState: RestaurantState(),
//            reducer: restaurantReducer,
//            environment: .init(
//                client: .mock,
//                mainQueue: .main.eraseToAnyScheduler())
//        )
//
//        let testRestaurants: [Restaurant] = [
//            Restaurant(address: "Seoul",
//                       category: "Turkish food",
//                       name: "SalamSeoul"),
//            Restaurant(address: "Seoul",
//                       category: "Turkish food",
//                       name: "Choo Kebab"),
//            Restaurant(address: "Seoul",
//                       category: "Turkish food",
//                       name: "Hyunho Kebab"),
//        ]
//
//        let scheduler = DispatchQueue.testScheduler
//
//        store.assert(
//            .send(.startObserve),
//            .do {
//                // Advance the scheduler by 1 second to allow the effect to complete
//                scheduler.advance(by: 5)
//            },
//            .receive(.updateRestaurants(.success(testRestaurants))) {
//                XCTAssertEqual($0.restaurants, testRestaurants)
//            }
//        )
//    }
}
