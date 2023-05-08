//
//  PrayerTimingFeatureTest.swift
//  PrayerTimingFeatureTest
//
//  Created by 추현호 on 2023/05/08.
//

import XCTest
import ComposableArchitecture
@testable import SalamSeoul


final class PrayerTimingFeatureTest: XCTestCase {
    
    @MainActor
    func testFetchTimingsSuccess() async {
        let store = TestStore(
            initialState: CalendarState(),
            reducer: calendarReducer,
            environment: .init(
                calendarClient: .live,
                mainQueue: .main.eraseToAnyScheduler())
        )
        
        let testTimings: PrayerTime = PrayerTime(
            Fajr: "04:17 (KST)",
            Sunrise: "05:37 (KST)",
            Dhuhr: "12:29 (KST)",
            Asr: "16:16 (KST)",
            Sunset: "19:22 (KST)",
            Maghrib: "19:22 (KST)",
            Isha: "20:42 (KST)",
            Imsak: "04:07 (KST)",
            Midnight: "00:29 (KST)",
            Firstthird: "22:47 (KST)",
            Lastthird: "02:12 (KST)")
        
        
        await store.send(.fetchItem("2020/05", 1)) { state in
            state.isLoading = true
        }
        
        await store.receive(.fetchItemResponse(.success(testTimings))) { state in
            state.timing = testTimings
            state.isLoading = false
        }
        
    }
    
}
