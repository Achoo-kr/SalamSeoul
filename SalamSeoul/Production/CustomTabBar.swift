//
//  CustomTabBar.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/05/03.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var selectedTab: Int

    let icons = ["fork.knife", "text.magnifyingglass", "alarm", "person"]
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ForEach(0..<icons.count) { index in
                    Spacer()
                    Image(systemName: icons[index])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedTab == index ? .green : .black.opacity(0.5))
                        .onTapGesture {
                            withAnimation {
                                selectedTab = index
                            }
                        }
                    Spacer()
                }
            }
            .padding()
            .background(Color(.gray))
            .clipShape(Capsule())
            .shadow(radius: 10)
            .padding(.horizontal)
        }
        .padding(.bottom, 8)
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(0))
    }
}
