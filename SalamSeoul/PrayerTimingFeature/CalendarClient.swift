//
//  CalendarClient.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import Foundation
import ComposableArchitecture

//API 통신
struct CalendarClient {
    //calendarByCity/2017/4?city=Seoul&country=South%20Korea
    //서울 한정으로 할꺼니까 도시는 고정해놓고 년 월을 받고 day로 원하는 날짜로 인덱스 접근.
    var fetchCalendarItem: (_ yearAndMonth: String, _ day: Int) -> Effect<PrayerTime, Failure>
    
    struct Failure: Error, Equatable {}
}

extension CalendarClient {
    static let live = Self(
        fetchCalendarItem: { yearAndMonth, day in
            Effect.task{
                let (data, _) = try await URLSession.shared
                    .data(from: URL(string:
                                        "http://api.aladhan.com/v1/calendarByCity/\(yearAndMonth)?city=Seoul&country=South%20Korea&method=2")!)
                let result = try JSONDecoder().decode(CalendarResponse.self, from: data)
                
                // 현재 3일이면 인덱스는 2이기 때문에 -1 해준다
                return result.data[day-1].timings
            }
            .mapError { _ in Failure() }
            .eraseToEffect()
        }
    )
}
