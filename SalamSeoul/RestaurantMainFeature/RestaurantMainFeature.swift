//
//  RestaurantMainFeature.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/26.
//

import ComposableArchitecture
import SwiftUI

struct RestaurantFeature: ReducerProtocol {
    struct State: Equatable {
        var restaurants: [Restaurant]
        var filteredRestaurants: [Restaurant] {
            if searchText.isEmpty {
                return restaurants
            }
            return restaurants.filter {
                $0.name.contains(searchText) || $0.category.contains(searchText) || $0.address.contains(searchText) || $0.certifiedState.contains(searchText)
            }
        }

        var searchText: String
        var isSearching: Bool

        init() {
            restaurants = []
            searchText = ""
            isSearching = false
        }
    }
    
    enum Action: Equatable {
        case startObserve
        case changeSearchText(String)
        case resetSearchText
        case updateRestaurants(Result<[Restaurant], FirebaseApiClient.ApiFailure>)
    }
    
    @Dependency(\.firebaseApi) var firebaseApi
    @Dependency(\.mainQueue) var mainQueue
    
    func reduce(into state: inout State, action: Action) -> EffectPublisher<Action, Never> {
        switch action {
        case let .changeSearchText(text):
            state.searchText = text
            state.isSearching = !state.searchText.isEmpty
            return .none
        case .resetSearchText:
            state.searchText = ""
            state.isSearching = false
            return .none
        case .startObserve:
            return self.firebaseApi
                .updateSnapshot()
                .receive(on: self.mainQueue)
                .catchToEffect()
                .map(Action.updateRestaurants)
        case let .updateRestaurants(.success(restaurants)):
            state.restaurants = restaurants
            return .none
        case let .updateRestaurants(.failure(failure)):
            print("error: \(failure)")
            return .none

        }
    }
}






////MARK: - State
//public struct RestaurantState: Equatable {
//    public var restaurants: [Restaurant]
//    public var filteredRestaurants: [Restaurant] {
//        if searchText.isEmpty {
//            return restaurants
//        }
//        return restaurants.filter {
//            $0.name.contains(searchText) || $0.category.contains(searchText) || $0.address.contains(searchText) || $0.certifiedState.contains(searchText)
//        }
//    }
//
//    public var searchText: String
//    public var isSearching: Bool
//
//    public init() {
//        restaurants = []
//        searchText = ""
//        isSearching = false
//    }
//}

////MARK: - Action
//public enum RestaurantAction: Equatable {
//    case startObserve
//    case changeSearchText(String)
//    case resetSearchText
//    case updateRestaurants(Result<[Restaurant], FirebaseApiClient.ApiFailure>)
//}

////MARK: - Environment
//public struct RestaurantEnvironment {
//    var client: FirebaseApiClient
//    var mainQueue: AnySchedulerOf<DispatchQueue>
//
//    public init(client: FirebaseApiClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
//        self.client = client
//        self.mainQueue = mainQueue
//    }
//}

//MARK: - Reducer
//public let restaurantReducer = Reducer<RestaurantState, RestaurantAction, RestaurantEnvironment> { state, action, environment in
//    switch action {
//    case let .changeSearchText(text):
//        state.searchText = text
//        state.isSearching = !state.searchText.isEmpty
//        return .none
//    case .resetSearchText:
//        state.searchText = ""
//        state.isSearching = false
//        return .none
//    case .startObserve:
//        return environment.client
//            .updateSnapshot()
//            .receive(on: environment.mainQueue)
//            .catchToEffect()
//            .map(RestaurantAction.updateRestaurants)
//    case let .updateRestaurants(.success(restaurants)):
//        state.restaurants = restaurants
//        return .none
//    case let .updateRestaurants(.failure(failure)):
//        print("error: \(failure)")
//        return .none
//
//    }
//}
