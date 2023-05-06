//
//  SalamKoreaProView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/05/06.
//

import SwiftUI

struct SalamKoreaProView: View {
    var body: some View {
        ZStack{
            Image("bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
       
    }
}

struct SalamKoreaProView_Previews: PreviewProvider {
    static var previews: some View {
        SalamKoreaProView()
    }
}
