//
//  CalendarDomain.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import Foundation
import SwiftUI
import ComposableArchitecture

// 도메인 + 상태
struct CalendarState: Equatable {
    var timing: PrayerTime? = nil
    var isLoading: Bool = false
}

// 도메인 + 액션
enum CalendarAction: Equatable {
    case fetchItem(_ yearAndMonth: String, _ day: Int)
    case fetchItemResponse(Result<PrayerTime, CalendarClient.Failure>)
}

struct CalendarEnvironment {
    var calendarClient: CalendarClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

let calendarReducer = Reducer<CalendarState, CalendarAction, CalendarEnvironment> {
    state, action, environment in
    switch action {
    case .fetchItem(let yearAndMonth, let day):
        state.isLoading = true
        return environment.calendarClient
            .fetchCalendarItem(yearAndMonth, day)
            .catchToEffect(CalendarAction.fetchItemResponse)
    case .fetchItemResponse(.success(let timing)):
        state.timing = timing
        state.isLoading = false
        return .none
    case .fetchItemResponse(.failure):
        state.timing = nil
        state.isLoading = false
        return .none
        
    }
}

