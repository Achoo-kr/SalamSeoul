//
//  RestaurantMainFeatureTest.swift
//  RestaurantMainFeatureTest
//
//  Created by 추현호 on 2023/05/09.
//

@testable import SalamSeoul
import ComposableArchitecture
import XCTest

class RestaurantFeatureTests: XCTestCase {
    
    func testChangeSearchText() {
        let store = TestStore(initialState: RestaurantFeature.State(), reducer: AnyReducer(RestaurantFeature()), environment: ())
        
        let expectedText = "test"
        store.send(.changeSearchText(expectedText)) {
            $0.searchText = expectedText
            $0.isSearching = true
        }
    }
    
    func testResetSearchText() {
        var initialState = RestaurantFeature.State()
        initialState.searchText = "someText"
        initialState.isSearching = true
        
        let store = TestStore(initialState: initialState, reducer: AnyReducer(RestaurantFeature()), environment: ())
        
        store.send(.resetSearchText) {
            $0.searchText = ""
            $0.isSearching = false
        }
    }
}
