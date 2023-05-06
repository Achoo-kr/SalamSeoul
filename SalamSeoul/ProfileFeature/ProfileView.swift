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
                                //
                            } label: {
                                HStack{
                                    Text("Privacy")
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
