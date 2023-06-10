//
//  PrayerTimingView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import SwiftUI
import ComposableArchitecture

struct PrayerTimingView: View {
    
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    let store: Store<CalendarState, CalendarAction>
    
    let currentDate = Date()
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let englishLocale = Locale(identifier: "en_US_POSIX")
        formatter.locale = englishLocale
        return formatter.string(from: currentDate)
    }
    
    var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        let englishLocale = Locale(identifier: "en_US_POSIX")
        formatter.locale = englishLocale
        return formatter.string(from: currentDate)
    }
    
    var day: Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        return day
    }
    
    private func getTimeOnly(_ time: String) -> String {
        let separated = time.components(separatedBy: " ")
        let timeOnly = separated[0]
        return timeOnly
    }
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack{
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    
                    if selectedLanguage == "Arabic" {
                        Image("Prayer Time Arabic")
                            .padding(.vertical)
                    } else {
                        Image("Prayer Time")
                            .padding(.vertical)
                    }
                    
                    Text("Times are based on Seoul")
                    
                    if !viewStore.state.isLoading {
                        ScrollView {
                            PrayerTimingCellView(alarmName: NSLocalizedString("Fajr", comment: ""), alarmTime: getTimeOnly(viewStore.state.timing?.Fajr ?? "None"))
                            PrayerTimingCellView(alarmName: NSLocalizedString("Sunrise", comment: ""), alarmTime: getTimeOnly(viewStore.state.timing?.Sunrise ?? "None"))
                            PrayerTimingCellView(alarmName: NSLocalizedString("Dhuhr", comment: ""), alarmTime: getTimeOnly(viewStore.state.timing?.Dhuhr ?? "None"))
                            PrayerTimingCellView(alarmName: NSLocalizedString("Asr", comment: ""), alarmTime: getTimeOnly(viewStore.state.timing?.Asr ?? "None"))
                            PrayerTimingCellView(alarmName: NSLocalizedString("Maghrib", comment: ""), alarmTime: getTimeOnly(viewStore.state.timing?.Maghrib ?? "None"))
                            PrayerTimingCellView(alarmName: NSLocalizedString("Isha", comment: ""), alarmTime: getTimeOnly(viewStore.state.timing?.Isha ?? "None"))
                        }
                        .padding(.bottom, 80)
                    } else {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
            }
            .onAppear{
                viewStore.send(.fetchItem("\(year)/\(month)", day))
            }
        }
    }
}

struct PrayerTimingView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerTimingView(store: .init(
            initialState: CalendarState(),
            reducer: calendarReducer,
            environment: .init(
                calendarClient: .live,
                mainQueue: .main.eraseToAnyScheduler())
        ))
        .environment(\.locale, .init(identifier: "ar"))
    }
}
