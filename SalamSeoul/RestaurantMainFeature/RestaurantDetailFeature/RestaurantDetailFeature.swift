//
//  RestaurantDetailFeature.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/26.
//


import ComposableArchitecture
import SwiftUI

//MARK: - State
public struct RestaurantDetailState: Equatable {
    public var restaurant: Restaurant

    public init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
}

//MARK: - Action
public enum RestaurantDetailAction: Equatable {
    case bookmarkButtonTapped
}

//MARK: - Environment
public struct RestaurantDetailEnvironment {
    var client: FirebaseApiClient
    var mainQueue: AnySchedulerOf<DispatchQueue>

    public init(client: FirebaseApiClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.client = client
        self.mainQueue = mainQueue
    }
}

//MARK: - Reducer
public let restaurantDetailReducer = Reducer<RestaurantDetailState, RestaurantDetailAction, RestaurantDetailEnvironment> { state, action, environment in
    switch action {
    case .bookmarkButtonTapped:
        // 찜하기 기능 나중에 추가 예정
        return .none
    }
}
