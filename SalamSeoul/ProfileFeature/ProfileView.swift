//
//  ProfileView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAuth
import AuthenticationServices

struct ProfileView: View {
    init(store: Store<RegistrationState, RegistrationAction>) {
        self.store = store
    }
    let store: Store<RegistrationState, RegistrationAction>
    @AppStorage("uid") var userID: String = ""
    @State private var showAlert = false
    @State var isLoading: Bool = false
    @AppStorage("isPro", store: EntitlementManager.userDefaults) var hasPro: Bool = false
    let termsText: String = """
                                            Terms & Conditions
                                            By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to .

                                            is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.

                                            The SeoulSalam app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the SeoulSalam app won’t work properly or at all.

                                            The app does use third-party services that declare their Terms and Conditions.

                                            Link to Terms and Conditions of third-party service providers used by the app

                                            AdMob
                                            You should be aware that there are certain things that will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi or provided by your mobile network provider, but cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left.

                                            If you’re using the app outside of an area with Wi-Fi, you should remember that the terms of the agreement with your mobile network provider will still apply. As a result, you may be charged by your mobile provider for the cost of data for the duration of the connection while accessing the app, or other third-party charges. In using the app, you’re accepting responsibility for any such charges, including roaming data charges if you use the app outside of your home territory (i.e. region or country) without turning off data roaming. If you are not the bill payer for the device on which you’re using the app, please be aware that we assume that you have received permission from the bill payer for using the app.

                                            Along the same lines, cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, cannot accept responsibility.

                                            With respect to ’s responsibility for your use of the app, when you’re using the app, it’s important to bear in mind that although we endeavor to ensure that it is updated and correct at all times, we do rely on third parties to provide information to us so that we can make it available to you. accepts no liability for any loss, direct or indirect, you experience as a result of relying wholly on this functionality of the app.

                                            At some point, we may wish to update the app. The app is currently available on iOS – the requirements for the system(and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. does not promise that it will always update the app so that it is relevant to you and/or works with the iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, We may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you. Unless we tell you otherwise, upon any termination, (a) the rights and licenses granted to you in these terms will end; (b) you must stop using the app, and (if needed) delete it from your device.

                                            Changes to This Terms and Conditions

                                            I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.

                                            These terms and conditions are effective as of 2023-05-08

                                            Contact Us

                                            If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at hyunho4178@naver.com.

                                            This Terms and Conditions page was generated by App Privacy Policy Generator
                                            
                                            """
    
    var body: some View {
        NavigationStack{
            WithViewStore(self.store) { viewStore in
                ZStack{
                    Image("bg")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                    Color.black.ignoresSafeArea()
                        .opacity(isLoading ? 0.3 : 0.0)
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                    VStack(alignment: .leading){
                        Spacer()
                        if !hasPro {
                            BannerAd(unitID: "ca-app-pub-7454589661664486/9787009387")
                                .frame(height: 50)
                        }
                        if !viewStore.state.isSignedIn {
                            VStack(alignment: .leading) {
                                Text("Sign In")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.title3)
                                    .padding(.top)
                                HStack {
                                    
                                    SignInWithAppleButton { (request) in
                                        viewStore.send(.getNonce)
                                        request.requestedScopes = [.email, .fullName]
                                        viewStore.send(.getSha256(nonce: viewStore.state.nonce))
                                        request.nonce = viewStore.state.requestedNonce
                                    } onCompletion: { (result) in
                                        switch result{
                                        case .success(let user):
                                            isLoading = true
                                            guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                                                print("error with firebase")
                                                return
                                            }
                                            viewStore.send(.authenticate(credential: credential, nonce: viewStore.state.nonce))
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                viewStore.send(.appleSigninResponse)
                                                userID = Auth.auth().currentUser?.uid ?? ""
                                                isLoading = false
                                            }
                                            
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                            
                                        }
                                    }
                                    .signInWithAppleButtonStyle(.black)
                                    .frame(height: 55)
                                    .clipShape(Capsule())
                                    .padding(.horizontal)
                                    
                                    NavigationLink {
                                        RegistrationView(store: .init(
                                            initialState: RegistrationState(),
                                            reducer: registrationReducer,
                                            environment: .init(
                                                client: .live,
                                                mainQueue: .main.eraseToAnyScheduler())
                                        ))
                                    } label: {
                                        Text("Sign in with Email")
                                            .font(.footnote)
                                            .frame(width: 140, height: 55)
                                            .foregroundColor(.white)
                                            .background(Color.black)
                                            .clipShape(Capsule())
                                            .padding(.horizontal)
                                        
                                    }
                                    Spacer()
                                    
                                }
                            }
                        } else {
                            VStack(alignment: .leading) {
                                Text("Welcome!")
                                    .foregroundColor(.black)
                                Text(Auth.auth().currentUser?.email ?? "")
                                    .foregroundColor(.black)
                                    .bold()
                                    .font(.largeTitle)
                            }
                            HStack{
                                Spacer()
                                Button {
                                    viewStore.send(.signOutButtonTapped)
                                } label: {
                                    Text("sign out")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                        
                        Divider()
                        VStack(alignment: .leading){
                            Text("SeoulSalam Pro")
                                .foregroundColor(.black)
                                .bold()
                                .font(.title3)
                                .padding(.top)
                            NavigationLink{
                                SalamKoreaProView()
                            } label: {
                                HStack{
                                    Text("SeoulSalam Pro")
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    Text(">")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                                
                            }
                            .padding(.vertical, 3)
                        }
                        
                        VStack(alignment: .leading){
                            Text("Settings")
                                .foregroundColor(.black)
                                .bold()
                                .font(.title3)
                                .padding(.top)
                            NavigationLink{
                                SelectingLanguageView()
                            } label: {
                                HStack{
                                    Text("Language")
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    Text(">")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                                
                            }
                            .padding(.vertical, 3)
                        }
                        
                        Divider()
                        VStack(alignment: .leading){
                            Text("Help")
                                .foregroundColor(.black)
                                .bold()
                                .font(.title3)
                                .padding(.top)
                            
                            NavigationLink{
                                ZStack{
                                    Image("bg")
                                        .resizable()
                                        .edgesIgnoringSafeArea(.all)
                                    ScrollView{
                                        Text(termsText)
                                            .padding()
                                            .foregroundColor(.black)
                                    }
                                }
                            } label: {
                                HStack{
                                    Text("Terms & Conditions")
                                        .foregroundColor(.black)
                                        .padding(.leading)
                                    Text(">")
                                        .foregroundColor(.black)
                                        .bold()
                                }
                            }
                            .padding(.vertical, 3)
                            
                            NavigationLink{
                                ZStack{
                                    Image("bg")
                                        .resizable()
                                        .edgesIgnoringSafeArea(.all)
                                    VStack(alignment: .center){
                                        Text("For Inquiries and Bug Report")
                                            .padding()
                                            .foregroundColor(.black)
                                        Text("hyunho4178@gmail.com")
                                    }
                                }
                            } label: {
                                HStack{
                                    Text("Inquiry")
                                        .padding(.leading)
                                    Text(">")
                                        .bold()
                                }
                            }
                            .padding(.vertical, 3)
                            
                            if viewStore.state.isSignedIn {
                                Button {
                                    showAlert = true
                                } label: {
                                    Text("Delete Account")
                                        .padding(.horizontal)
                                        .foregroundColor(.red)
                                        .opacity(0.8)
                                }
                                .padding(.vertical, 3)
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text("Warning"),
                                        message: Text("Are you sure you want to delete your account?"),
                                        primaryButton: .destructive(Text("Yes")) {
                                            viewStore.send(.deleteUser)
                                            userID = ""
                                        },
                                        secondaryButton: .cancel(Text("No"))
                                    )
                                }
                            }
                            Divider()
                            Spacer()
                        }
                        Spacer()
                        
                    }
                    .padding()
                    .onAppear{
                        viewStore.send(.updateSigningState)
                    }
                }
                
            }.accentColor(.black)
        }
        
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            store: .init(
                initialState: RegistrationState(),
                reducer: registrationReducer,
                environment: .init(
                    client: .live,
                    mainQueue: .main.eraseToAnyScheduler())
            )
        ).environment(\.locale, Locale(identifier: "ar"))
    }
}
