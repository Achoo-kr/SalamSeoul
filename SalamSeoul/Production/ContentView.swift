//
//  ContentView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/21.
//

import SwiftUI
import ComposableArchitecture
import GoogleMobileAds

struct ContentView: View {
    
    @State private var selectedTab = 0
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            
            VStack{
                TabView(selection: $selectedTab) {
                    RestaurantMainView(
                        store: .init(
                            initialState: RestaurantFeature.State(),
                            reducer: Reducer(
                                RestaurantFeature()
                            ).debug(),
                            environment: ()
                        )
                    )
                    .tag(0)
                    HaramDeterctorView()
                        .tag(1)
                    PrayerTimingView(
                        store: .init(
                            initialState: CalendarState(),
                            reducer: calendarReducer,
                            environment: .init(
                                calendarClient: .live,
                                mainQueue: .main.eraseToAnyScheduler())
                        )
                    )
                    .tag(2)
                    ProfileView(
                        store: .init(
                            initialState: RegistrationState(),
                            reducer: registrationReducer,
                            environment: .init(
                                client: .live,
                                mainQueue: .main.eraseToAnyScheduler())
                        )
                    )
                    .tag(3)
                }
            }.accentColor(.black)
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


