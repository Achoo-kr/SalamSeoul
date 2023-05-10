//
//  CalendarDomain.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import Foundation
import SwiftUI
import ComposableArchitecture

// State
struct CalendarState: Equatable {
    var timing: PrayerTime? = nil
    var isLoading: Bool = false
    var fajr: String = ""
    var sunrise: String = ""
    var dhuhr: String = ""
    var asr: String = ""
    var maghrib: String = ""
    var isha: String = ""
}

// Action
enum CalendarAction: Equatable {
    case fetchItem(_ yearAndMonth: String, _ day: Int)
    case fetchItemResponse(Result<PrayerTime, CalendarClient.Failure>)
}
// Environment
struct CalendarEnvironment {
    var calendarClient: CalendarClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
}

// Reducer
let calendarReducer = Reducer<CalendarState, CalendarAction, CalendarEnvironment> {
    state, action, environment in
    switch action {
    case .fetchItem(let yearAndMonth, let day):
        enum FetchItem {}
        state.isLoading = true
        return environment.calendarClient
            .fetchCalendarItem(yearAndMonth, day)
            .catchToEffect(CalendarAction.fetchItemResponse)
    case .fetchItemResponse(.success(let timing)):
        state.timing = timing
        state.isLoading = false
        return Effect.none
    case .fetchItemResponse(.failure):
        state.timing = nil
        state.isLoading = false
        return Effect.none
        
    }
}

