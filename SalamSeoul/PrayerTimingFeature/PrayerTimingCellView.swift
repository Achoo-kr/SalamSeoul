//
//  PrayerTimingCellView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/05/03.
//

import SwiftUI

struct PrayerTimingCellView: View {
    
    var alarmName: String
    var alarmTime: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(alarmName)
                    .padding(.horizontal)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                Text(alarmTime)
                    .padding(.top, 3)
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
            }
            Spacer()

            
        }
        .padding()
        .background(
            Rectangle()
                .foregroundColor(Color("CellColor"))
                .frame(height: 110)
                .cornerRadius(10)
                .padding(.horizontal)
        )
    }
}

struct PrayerTimingCellView_Previews: PreviewProvider {
    static var previews: some View {
        PrayerTimingCellView(alarmName: "Fajr", alarmTime: "alarmTime")

    }
}
