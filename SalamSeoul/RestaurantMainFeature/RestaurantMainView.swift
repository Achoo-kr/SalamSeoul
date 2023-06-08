//
//  RestaurantMainView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/26.
//

import ComposableArchitecture
import SwiftUI
import FirebaseAuth

////ca-app-pub-3940256099942544/2934735716
//BannerAd(unitID: "ca-app-pub-7454589661664486/9787009387")
//    .frame(height: 30)

struct RestaurantMainView: View {
    init(store: StoreOf<RestaurantFeature>) {
        self.store = store
        ViewStore(store).send(.startObserve)
    }
    
    private let store: StoreOf<RestaurantFeature>
    private var isSearch = false
    
    @AppStorage("selectedLanguage") var selectedLanguage: String?
    
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            NavigationView {
                ZStack{
                    Image("bg")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView(showsIndicators: false){
                        if selectedLanguage == "Arabic" {
                            Image("Seoul Salam Arabic")
                                .padding(.vertical)
                        } else {
                            Image("Seoul Salam")
                                .padding(.vertical)
                        }
                        NavigationLink {
                            ZStack {
                                Image("bg")
                                    .resizable()
                                    .edgesIgnoringSafeArea(.all)
                                VStack{
                                    Section {
                                        SearchField(viewStore: viewStore)
                                    }
                                    RestaurantList(viewStore: viewStore, certifiedState: "Halal Certified")
                                }
                            }
                        } label: {
                            if selectedLanguage == "Arabic" {
                                Image("Halal Certified Arabic")
                                    .shadow(radius: 10)
                                    .padding(.top)
                            } else {
                                Image("Halal Certified")
                                    .shadow(radius: 10)
                                    .padding(.top)
                            }
                        }
                        
                        NavigationLink {
                            ZStack {
                                Image("bg")
                                    .resizable()
                                    .edgesIgnoringSafeArea(.all)
                                VStack{
                                    Section {
                                        SearchField(viewStore: viewStore)
                                    }
                                    RestaurantList(viewStore: viewStore, certifiedState: "Self Certified")
                                }
                            }
                        } label: {
                            if selectedLanguage == "Arabic" {
                                Image("Self Certified Arabic")
                                    .shadow(radius: 10)
                                    .padding(.top)
                            } else {
                                Image("Self Certified")
                                    .shadow(radius: 10)
                                    .padding(.top)
                            }
                        }
                        
                        NavigationLink {
                            ZStack {
                                Image("bg")
                                    .resizable()
                                    .edgesIgnoringSafeArea(.all)
                                VStack{
                                    Section {
                                        SearchField(viewStore: viewStore)
                                    }
                                    RestaurantList(viewStore: viewStore, certifiedState: "Muslim Friendly")
                                }
                            }
                        } label: {
                            if selectedLanguage == "Arabic" {
                                Image("Muslim Friendly Arabic")
                                    .shadow(radius: 10)
                                    .padding(.top)
                            } else {
                                Image("Muslim Friendly")
                                    .shadow(radius: 10)
                                    .padding(.top)
                            }
                        }
                        
                        Spacer()
                    }.accentColor(.black)
                        .padding(.bottom, 70)
                }
                
            }
        }
    }
}

struct RestaurantMainView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMainView(
            store: .init(
                initialState: RestaurantFeature.State(),
                reducer: Reducer(
                    RestaurantFeature()
                ).debug(),
                environment: ()
            )
        )
    }
}



// 검색 필드 컴포넌트
struct SearchField: View {
    @ObservedObject var viewStore: ViewStoreOf<RestaurantFeature>
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding()
            TextField("Search by name, category or adress",
                      text: viewStore.binding(
                        get: \.searchText,
                        send: {.changeSearchText($0)}
                      ))
        }
        .overlay(
            HStack {
                Spacer()
                if viewStore.state.isSearching {
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .foregroundColor(.gray)
                        .onTapGesture {
                            viewStore.send(.resetSearchText)
                        }
                }
            }
        )
    }
}

// 레스토랑 목록 컴포넌트
struct RestaurantList: View {
    @ObservedObject var viewStore: ViewStoreOf<RestaurantFeature>
    let certifiedState: String
    
    var body: some View {
        ScrollView {
            Section {
                LazyVStack(alignment: .leading){
                    ForEach(viewStore.state.filteredRestaurants, id: \.self) { restaurant in
                        if restaurant.certifiedState == self.certifiedState {
                            NavigationLink(
                                destination: RestaurantDetailView(store: .init(
                                    initialState: .init(restaurant: restaurant),
                                    reducer: restaurantDetailReducer,
                                    environment: .init(client: .live, mainQueue: .main.eraseToAnyScheduler())
                                )
                                ),
                                label: {
                                    RestaurantCell(restaurant: restaurant)
                                }
                            )
                        }
                    }
                }.padding(.bottom, 80)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

