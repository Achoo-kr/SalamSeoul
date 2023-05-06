//
//  RegistrationDomain.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import ComposableArchitecture
import FirebaseAuth
import SwiftUI
import AuthenticationServices
import FirebaseFirestore

enum RegistrationButtonState {
    case login
    case signUp
}

// MARK: - State
struct RegistrationState: Equatable {
    var activeState: RegistrationButtonState = .login
    var email: String = ""
    var password: String = ""
    var userName: String = ""
    var isPro: Bool = false
    var alertText: String?
    var isSignedIn: Bool = false
    var uid: String = ""
    var isSignedUp: Bool = false
    var backToProfileView: Bool = false
    // appleSignIn
    var nonce: String = ""
    var requestedNonce: String = ""
    var currentUserInfo: User = User(email: "", password: "", userName: "", isPro: false)
}

// MARK: - Action
enum RegistrationAction: Equatable {
    case didChangeState(state: RegistrationButtonState)
    case signUpButtonTapped(username: String, email: String, password: String)
    case signUpResponse(Result<AuthDataResult, FirebaseAuthClient.ApiFailure>)
    case loginButtonTapped(email: String, password: String)
    case loginResponse(Result<AuthDataResult, FirebaseAuthClient.ApiFailure>)
    case signOutButtonTapped
    case isProChanged(Bool)
    case setAlertText(String?)
    case deleteUser
    case updateSigningState
    case initializeAlertText
    case getNonce
    case getSha256(nonce: String)
    case appleSigninResponse
    case authenticate(credential: ASAuthorizationAppleIDCredential, nonce: String)
    
}

// MARK: - Action

struct RegistrationEnvironment {
    var client: FirebaseAuthClient
    var mainQueue: AnySchedulerOf<DispatchQueue>
    
    init(client: FirebaseAuthClient, mainQueue: AnySchedulerOf<DispatchQueue>) {
        self.client = client
        self.mainQueue = mainQueue
    }
}

// MARK: - Reducer

let registrationReducer = Reducer<RegistrationState, RegistrationAction, RegistrationEnvironment> { state, action, environment in
    switch action {
    case .didChangeState(let selectedState):
        state.activeState = selectedState
        return . none
        
    case .signUpButtonTapped(let username ,let email, let password):
        guard !email.isEmpty, !password.isEmpty, !username.isEmpty else { break }
        let newUser = User(email: email, password: password, userName: username, isPro: false)
        return environment.client
            .signUpWithEmail(newUser.email, newUser.password)
            .catchToEffect()
            .map(RegistrationAction.signUpResponse)
            .eraseToEffect()

    case let .signUpResponse(.success(authDataResult)):
//        state.isSignedUp = true
        state.alertText = "Successfully signed up!"
        return .none
        
    case let .signUpResponse(.failure(apiFailure)):
        return .concatenate(
            Effect(value: .setAlertText(apiFailure.message)))
        
    case .loginButtonTapped(let email, let password):
           return environment.client.signInWithEmail(email, password)
               .receive(on: environment.mainQueue)
               .catchToEffect()
               .map(RegistrationAction.loginResponse)
        
    case let .loginResponse(.failure(apiFailure)):
        state.alertText = "Check your email or password again"
        return .none
        
    case .loginResponse(.success(let authDataResult)):
        state.uid = authDataResult.user.uid
        state.isSignedIn = true
        state.alertText = "Successfully signed in!"
        return .none
        
    case .signOutButtonTapped:
        environment.client.signOut()
        state.isSignedIn = false
        return .none
    
    case let .isProChanged(isPro):
        state.isPro = isPro
        return .none
        
    case let .setAlertText(alertText):
            state.alertText = alertText ?? ""
            return .none
    case .deleteUser:
        environment.client.deleteAccount()
        state.isSignedIn = false
        return .none
    case .initializeAlertText:
        state.alertText = ""
        return .none
    case . updateSigningState:
        if Auth.auth().currentUser != nil {
            state.isSignedIn = true
        } else {
            state.isSignedIn = false
        }
        
    case .getNonce:
        state.nonce = environment.client.randomNonceString()
        return .none
        
    case .getSha256(let nonce):
        state.requestedNonce = environment.client.sha256(nonce)
        return .none
        
    case .appleSigninResponse:
        state.isSignedIn = true
        if let currentUser = Auth.auth().currentUser {
            let user = User(email: currentUser.email ?? "", password: "", userName: "", isPro: false)
            Firestore.firestore().collection("Users").document(currentUser.uid).setData(user.toFirestoreData()) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
        return .none
        
    case .authenticate(let credential, let nonce):
        environment.client.authenticate(credential, nonce)
        return .none
    }
    return .none
}
