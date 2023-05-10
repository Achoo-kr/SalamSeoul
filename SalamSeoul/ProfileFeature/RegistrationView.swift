//
//  EmailSigninView.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAuth

struct RegistrationView: View {
    @State var emailTextForSignUp: String = ""
    @State var passwordForSignUp: String = ""
    @State var username: String = ""
    
    @State var emailTextForSignIn: String = ""
    @State var passwordForSignIn: String = ""
    @AppStorage("uid") var userID: String = ""
    @State private var showAlert = false
    @State private var isLoading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init(store: Store<RegistrationState, RegistrationAction>) {
        self.store = store
    }
    let store: Store<RegistrationState, RegistrationAction>
    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                Image("bg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)
                Color.black.ignoresSafeArea()
                    .opacity(isLoading ? 0.3 : 0.0)
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                VStack(spacing: 40) {
                    
                    Spacer()
                    HStack(spacing: 40) {
                        Button {
                            viewStore.send(.didChangeState(state: .login))
                        } label: {
                            Text("Sign in")
                                .foregroundColor(viewStore.state.activeState == .login ?
                                                 Color.black : Color.yellow )
                            
                        }
                        Button {
                            viewStore.send(.didChangeState(state: .signUp))
                        } label: {
                            Text("Sign Up")
                                .foregroundColor(viewStore.state.activeState == .signUp ?
                                                 Color.black : Color.yellow )
                            
                        }
                        
                        
                    }
                    switch viewStore.state.activeState {
                    case .login:
                            EmailSigninView(action: {
                                isLoading = true
                                viewStore.send(.loginButtonTapped(email: emailTextForSignIn, password: passwordForSignIn))
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    userID = Auth.auth().currentUser?.uid ?? ""
                                    showAlert = true
                                    isLoading = false
                                }
                                
                            }, emailText: $emailTextForSignIn, password: $passwordForSignIn)
                    case .signUp:
                        EmailSignUpView(action: {
                            isLoading = true
                            viewStore.send(.signUpButtonTapped(username: username, email: emailTextForSignUp, password: passwordForSignUp))
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                emailTextForSignUp = ""
                                passwordForSignUp = ""
                                username = ""
                                showAlert = true
                                isLoading = false
                            }
                        }, username: $username, emailText: $emailTextForSignUp, password: $passwordForSignUp)
                    }
                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Alert"),
                        message: Text(viewStore.state.alertText ?? ""),
                        dismissButton: .default(Text("OK")) {
                            if Auth.auth().currentUser != nil {
                                presentationMode.wrappedValue.dismiss()
                            }
                            viewStore.send(.initializeAlertText)
                        }
                    )
            }
            }

        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    @State static var emailText: String = ""
    @State static var password: String = ""
    static var previews: some View {
        RegistrationView(
            store: .init(
                initialState: RegistrationState(),
                reducer: registrationReducer,
                environment: .init(
                    client: .live,
                    mainQueue: .main.eraseToAnyScheduler())
            )
        )
    }
}

struct EmailSigninView: View {
    var action: () -> ()
    @Binding var emailText: String
    @Binding var password: String
    @State var isHidden: Bool = true
    @AppStorage("uid") var userID: String = ""
    var body: some View {
        VStack{
            CustomTextField(txt: $emailText,
                            label: NSLocalizedString("Enter Email", comment: ""),
                            iconName: "envelope.fill")
            
            HStack(alignment: .center) {
                Image(systemName: "key.fill")
                    .resizable()
                    .frame(width: 20, height: 30)
                    .padding([.leading], 13)
                Spacer()
                if isHidden {
                    SecureField(
                        "Enter Password",
                        text: $password
                    )
                    .autocapitalization(.none)
                    .padding([.trailing], 10)
                }else {
                    TextField(
                        "Enter Password",
                        text: $password
                    )
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding([.trailing], 10)
                }
                
                Button {
                    isHidden = !isHidden
                } label: {
                    if isHidden{
                        Image(systemName: "eye.slash")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .tint(.black)
                    } else {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .tint(.black)
                    }
                }.padding([.trailing], 10)
                
            }
            .frame(height: 50, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.black, lineWidth: 1)
            )
            .padding([.leading, .trailing], 16)
            .cornerRadius(10)
            
            HStack{
                Button {
                    action()
                } label: {
                    Text("Sign In")
                        .foregroundColor(.white)
                }
                .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                    .foregroundColor(Color.black)
                    .frame(width: 150, height: 50, alignment: .center))
                .padding()
                
            }
        }
    }
}

struct EmailSignUpView: View {
    var action: () -> ()
    @Binding var username: String
    @Binding var emailText: String
    @Binding var password: String
    @State var isHidden: Bool = true
    var body: some View {
        VStack {
            CustomTextField(txt: $username,
                            label: NSLocalizedString("Enter Username", comment: ""),
                            iconName: "person.fill")
            CustomTextField(txt: $emailText,
                            label: NSLocalizedString("Enter Email", comment: ""),
                            iconName: "envelope.fill")
            
            
            HStack(alignment: .center) {
                Image(systemName: "key.fill")
                    .resizable()
                    .frame(width: 20, height: 30)
                    .padding([.leading], 13)
                Spacer()
                if isHidden {
                    SecureField(
                        "Enter Password",
                        text: $password
                    )
                    .autocapitalization(.none)
                    .padding([.trailing], 10)
                }else {
                    TextField(
                        "Enter Password",
                        text: $password
                    )
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding([.trailing], 10)
                }
                
                Button {
                    isHidden = !isHidden
                } label: {
                    if isHidden{
                        Image(systemName: "eye.slash")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .tint(.black)
                    } else {
                        Image(systemName: "eye")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .tint(.black)
                    }
                }.padding([.trailing], 10)
                
            }
            .frame(height: 50, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.black, lineWidth: 1)
            )
            .padding([.leading, .trailing], 16)
            .cornerRadius(10)
            
            Button {
                action()
            } label: {
                Text("Sign Up")
                    .foregroundColor(.white)
            }
            .background(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .foregroundColor(Color.black)
                .frame(width: 150, height: 50, alignment: .center))
            .padding(.top, 16)
            
            if username.isEmpty || emailText.isEmpty || password.isEmpty {
                Text("Please fill out the form")
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}

struct CustomTextField: View {
    @Binding var txt: String
    var label: String
    var iconName: String
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 25, height: 20)
                    .padding([.leading], 10)
                Spacer()
                TextField(
                    label,
                    text: $txt
                )
                .keyboardType(.emailAddress)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding([.trailing], 10)
            }
            .frame(height: 50, alignment: .center)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.black, lineWidth: 1.5)
            )
            .padding([.leading, .trailing], 16)
            .cornerRadius(10)
        }
    }
}
