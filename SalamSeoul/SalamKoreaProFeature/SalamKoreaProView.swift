//
//  SalamKoreaProView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/05/06.
//

import SwiftUI
import StoreKit

struct SalamKoreaProView: View {
    @EnvironmentObject private var entitlementManager: EntitlementManager
    
    @EnvironmentObject private var purchaseManager: PurchaseManager
    
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
                            Text("\(product.displayPrice) - \(product.displayName)")
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


