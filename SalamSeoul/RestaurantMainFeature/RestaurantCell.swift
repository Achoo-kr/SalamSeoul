//
//  RestaurantCell.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/26.
//

import SwiftUI

public struct RestaurantCell: View {
    private let restaurant: Restaurant
    
    public init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    public var body: some View {
        
        
        ZStack(alignment: .leading){
            Rectangle()
                .shadow(radius: 10)
                .cornerRadius(10)
                .foregroundColor(Color("CellColor"))
                .frame(height: 50)
                .padding(.horizontal)
            VStack(alignment: .leading) {
                Text(restaurant.name)
                    .lineLimit(1)
                    .padding(.horizontal, 30)
                    .bold()
                Text(restaurant.category)
                    .padding(.horizontal, 30)
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct RestaurantCell_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantCell(restaurant: Restaurant(address: "SalamSeoul", category: "Korean", certifiedState: "idk", name: "SeoulSalam")
        )
    }
}
