//
//  SalamKoreaProView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/05/06.
//

import SwiftUI
import StoreKit
import SafariServices

struct SalamKoreaProView: View {
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    @State var showPrivacyPolicy = false
    @State var showTermsOfService = false
    
    var body: some View {
        ZStack{
            Image("bg")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                if entitlementManager.hasPro {
                    Text("Thank you for purchasing pro!")
                } else {
                    Text("Products")
                    ForEach(purchaseManager.products) { product in
                        Button {
                            _ = Task<Void, Never> {
                                do {
                                    try await purchaseManager.purchase(product)
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            Text("\(product.displayName) (\(product.displayPrice))")
                                .foregroundColor(.white)
                                .padding()
                                .background(.blue)
                                .clipShape(Capsule())
                        }
                    }
                    
                    Button {
                        _ = Task<Void, Never> {
                            do {
                                try await AppStore.sync()
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("Restore Purchases")
                    }
                }
                
                HStack{
                    Spacer()
                    
                    Button {
                        showPrivacyPolicy = true
                    } label: {
                        Text("Privacy Policy")
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showPrivacyPolicy) {
                        SafariView(url:URL(string: "https://achoo-ios.tistory.com/31")!)
                    }
                    
                    Spacer()
                    
                    Text("|")
                    
                    Spacer()
                    
                    Button {
                        showTermsOfService = true
                    } label: {
                        Text("Terms Of Service")
                            .foregroundColor(.black)
                    }
                    .sheet(isPresented: $showTermsOfService) {
                        SafariView(url:URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/")!)
                    }
                    
                    Spacer()
                }
            }.task {
                _ = Task<Void, Never> {
                    do {
                        try await purchaseManager.loadProducts()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}
struct SalamKoreaProView_Previews: PreviewProvider {
    static var previews: some View {
        SalamKoreaProView()
    }
}


