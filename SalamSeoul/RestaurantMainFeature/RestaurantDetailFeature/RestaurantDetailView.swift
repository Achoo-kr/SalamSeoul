//
//  RestaurantDetailView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/26.
//

import SwiftUI
import ComposableArchitecture
import MapKit
import WebKit
import SafariServices

struct RestaurantDetailView: View {
    public init(store: Store<RestaurantDetailState, RestaurantDetailAction>) {
        self.store = store
    }
    
    @State var showSafari = false
    @AppStorage("isPro", store: EntitlementManager.userDefaults) var hasPro: Bool = false
    
    public let store: Store<RestaurantDetailState, RestaurantDetailAction>
    
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack(alignment: .leading) {
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    if !hasPro {
                        ////ca-app-pub-3940256099942544/2934735716
                        BannerAd(unitID: "ca-app-pub-7454589661664486/9787009387")
                            .frame(height: 50)
                    }
                    ScrollView{
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 3){
                                Text(viewStore.state.restaurant.name)
                                    .foregroundColor(.black)
                                    .font(.largeTitle)
                                    .bold()
                                HStack{
                                    Text(viewStore.state.restaurant.category)
                                        .foregroundColor(.black)
                                        .font(.subheadline)
                                    Text("•")
                                        .foregroundColor(.black)
                                    Text(viewStore.state.restaurant.certifiedState)
                                        .foregroundColor(.black)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.vertical)
                            
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 3){
                                HStack{
                                    Image(systemName: "phone")
                                        .foregroundColor(.black)
                                    Text("Contact")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                Button(action: {
                                    let phone = "tel://"
                                    let phoneNumberformatted = phone + viewStore.state.restaurant.phoneNumber
                                    guard let url = URL(string: phoneNumberformatted) else { return }
                                    UIApplication.shared.open(url)
                                }) {
                                    Text(viewStore.state.restaurant.phoneNumber)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 3){
                                HStack{
                                    Image(systemName: "globe")
                                        .foregroundColor(.black)
                                    Text("Website")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                if viewStore.state.restaurant.website != "none" {
                                    Button {
                                        showSafari = true
                                    } label: {
                                        Text(viewStore.state.restaurant.website)
                                            .foregroundColor(.blue)
                                    }
                                    .sheet(isPresented: $showSafari) {
                                        SafariView(url:URL(string: viewStore.state.restaurant.website)!)
                                    }
                                } else {
                                    Text(viewStore.state.restaurant.website)
                                        .foregroundColor(.black)
                                }
                                
                            }
                            .padding(.vertical)
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 3){
                                HStack{
                                    Image(systemName: "signpost.right")
                                        .foregroundColor(.black)
                                    Text("Address")
                                        .foregroundColor(.black)
                                        .font(.headline)
                                }
                                Text(viewStore.state.restaurant.address)
                                    .foregroundColor(.black)
                                    .padding(.leading)
                            }
                            .padding(.vertical)
                            
                            Divider()
                            
                            Text("The location information on the map may not be accurate.\nPlease search for the exact location or contact the restaurant")
                                .padding(.vertical, 3)
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(.red)
                            
                            MapView(address: "Jongno-gu 309, Seoul")
                                .frame(height: 180)
                            
                            
                            
                        }
                        .padding()
                        Spacer()
                    }.padding(.bottom, 80)
                }
            }
        }
    }
}

struct RestaurantDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantDetailView(
            store: .init(
                initialState: .init(
                    restaurant: .init()
                ),
                reducer: restaurantDetailReducer,
                environment: .init(
                    client: .mock,
                    mainQueue: .main.eraseToAnyScheduler()
                )
            )
        )
    }
}

struct MapView: UIViewRepresentable {
    let address: String
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let placemark = placemarks?.first, let location = placemark.location {
                let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                uiView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location.coordinate
                uiView.addAnnotation(annotation)
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        
    }
    
}
