//
//  HaramDeterctorView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/27.
//

import SwiftUI
import VisionKit

struct HaramDeterctorView: View {
    @State private var scannedText = ""
    @FocusState var focusState: Bool
    @State var liveScan = false
    
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    var body: some View {
        NavigationStack {
            ZStack{
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all )
                VStack {
                    if selectedLanguage == "English" {
                        Image("Haram Detector")
                            .padding(.vertical)
                    } else {
                        Image("Haram Detector Arabic")
                            .padding(.vertical)
                    }
                    
                    BannerAd(unitID: "ca-app-pub-7454589661664486/9787009387")
                        .frame(height: 50)
                    
                    ScrollView {
                        
                        Text("Scan Korean Text Only")
                            .foregroundColor(.black)
                            .padding()
                        
                        if scannedText != "" {
                            TextEditor(text: $scannedText)
                                .frame(height: 300)
                                .cornerRadius(30)
                                .shadow(radius: 40)
                                .focused($focusState)
                        }
                        
                        let suspiciousIngredients = haramIngredientsList.filter { ingredient in
                            scannedText.contains(ingredient.key)
                        }
                        if !suspiciousIngredients.isEmpty {
                            if selectedLanguage == "English" {
                                Image("suspicious")
                                    .shadow(radius: 10)
                                    .padding()
                            } else {
                                Image("Suspicious Arabic")
                                    .shadow(radius: 10)
                                    .padding()
                            }
                            Text("This food product contains...")
                                .foregroundColor(.black)
                            ForEach(Array(suspiciousIngredients), id: \.key) { ingredient in
                                Text("\(ingredient.key) (\(ingredient.value))")
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                        
                        
                        if DataScannerViewController.isSupported {
                            Button("Scan with Camera") {
                                liveScan.toggle()
                                focusState = false
                            }
                            .buttonStyle(.borderedProminent)
                        } else {
                            Text("Does not support Haram Detector from camera scan.")
                                .foregroundColor(.black)
                        }
                        
                        Text("This app only detects the ingredients listed on the food packaging and provides limited halal information. Therefore, please be advised that you are solely responsible for the purchase and consumption of food.")
                            .bold()
                            .foregroundColor(.red)
                            .background(Color.black)
                            .padding()
                        Spacer()
                    }
                    .padding(.bottom, 50)
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button {
                                focusState = false
                            } label: {
                                Image(systemName: "keyboard.chevron.compact.down.fill")
                            }
                        }
                    }
                    .sheet(isPresented: $liveScan) {
                        LiveTextFromCameraScan(liveScan: $liveScan, scannedText: $scannedText)
                }
                }
            }
        }
    }
}
struct HaramDeterctorView_Previews: PreviewProvider {
    static var previews: some View {
        HaramDeterctorView()
    }
}

let haramIngredientsList: [String:String] = [
    "돼지고기":"pork",
    "쇠고기":"beef",
    "닭고기":"chicken",
    "젤라틴":"gelatin",
    "동물성유지":"animal fat",
    "동물성":"from animal",
    "레시틴":"lecithin",
    "유청":"whey",
    "유청가루":"whey powder",
    "합성향료":"synthetic fragrance",
    "합성착향료":"synthetic fragrance",
    "유당":"lactose",
    "인공버터향":"artificial butter flavor",
    "버터":"butter",
    "버터밀크":"butter milk",
    "카제인":"casein",
    "카제인염":"caseinates",
    "치즈":"cheese",
    "크림":"cream",
    "햄":"ham",
    "와인":"wine",
    "알코올":"alcohol",
    "L-시스테인":"L-Cysteine",
    "베이컨":"bacon"
]
