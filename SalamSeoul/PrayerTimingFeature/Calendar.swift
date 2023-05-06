//
//  Calendar.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import Foundation

struct CalendarResponse: Codable {
    let code: Int
    let status: String
    let data: [CalendarData]
}

struct CalendarData: Codable {
    let timings: PrayerTime
    let date: CalendarDate
    let meta: CalendarMeta
}

//타겟 데이터이므로 여기에 Equatable 프로토콜 추가
struct PrayerTime: Codable, Equatable {
    let Fajr, Sunrise, Dhuhr, Asr, Sunset, Maghrib, Isha, Imsak, Midnight, Firstthird, Lastthird: String
}

struct CalendarDate: Codable {
    let readable: String
    let timestamp: String
}

struct CalendarMeta: Codable {
    let latitude: Double
    let longitude: Double
    let timezone: String
    let method: CalendarMethod
}

struct CalendarMethod: Codable {
    let id: Int
    let name: String
    let params: CalendarParams
    let location: CalendarLocation
}

struct CalendarParams: Codable {
    let Fajr: Int
    let Isha: Int
}

struct CalendarLocation: Codable {
    let latitude: Double
    let longitude: Double
}
