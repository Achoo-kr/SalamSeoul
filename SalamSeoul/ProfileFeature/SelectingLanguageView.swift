//
//  SelectingLanguageView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/05/06.
//

import SwiftUI

struct SelectingLanguageView: View {
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    @State private var defaultLanguage: String = "English"
    @State private var showingConfirmation: Bool = false
    @State private var showingAlert: Bool = false
    @State var selected: String = ""
    
    var body: some View {
        
        ZStack {
            Image("bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack{
                Text("App System Language")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                Spacer()
                VStack{
                    Button {
                        selected = "English"
                        showingConfirmation.toggle()
                    } label: {
                        ZStack {
                            Color.black
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                            
                            Text("English")
                                .foregroundColor(.yellow)
                        }
                        .frame(height: 50)
                    }
                    .padding()
                    Button {
                        selected = "Arabic"
                        showingConfirmation.toggle()
                    } label: {
                        ZStack {
                            Color.black
                                .cornerRadius(10)
                                .padding(.horizontal, 30)
                            
                            Text("العربية")
                                .foregroundColor(.yellow)
                        }
                        .frame(height: 50)
                    }
                    .padding()
                }.alert(isPresented: $showingConfirmation) {
                    Alert(
                        title: Text("Do you really want to change the language setting?"),
                        message: nil,
                        primaryButton: .default(Text("Yes"), action: {
                            self.selectedLanguage = selected
                            defaultLanguage = selectedLanguage ?? ""
                            UserDefaults.standard.set([defaultLanguage], forKey: "AppleLanguages")
                        }),
                        secondaryButton: .cancel(Text("No"))
                    )
                }
                Spacer()
            }
        }
        
    }
}

struct SelectingLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectingLanguageView()
    }
}
