//
//  RegistrationFeatureTest.swift
//  RegistrationFeatureTest
//
//  Created by 추현호 on 2023/05/09.
//

import XCTest
import ComposableArchitecture
import FirebaseAuth
@testable import SalamSeoul

final class RegistrationFeatureTest: XCTestCase {

    //로그인, 로그아웃, 회원가입, 회원탈퇴 테스트
    
    
//    func testSignIn() {
//        let store = TestStore(
//            initialState: RegistrationState(),
//            reducer: registrationReducer,
//            environment: .init(
//                client: .live,
//                mainQueue: .main.eraseToAnyScheduler())
//        )
//
//        let dummyUser = User(
//            email: "11@11.com",
//            password: "111",
//            userName: "111",
//            isPro: false
//        )
//
//
//        store.send(.signUpButtonTapped(username: "111", email: "11@11.com", password: "111")) {
//                $0.email = "11@11.com"
//                $0.userName = "111"
//            }
//
//        store.receive(.signUpResponse(.success(authDataResult))) {
//                $0.alertText = "Successfully signed up!"
//            }
//
////            .do { self.testScheduler.advance(by: .seconds(1)) },
////            .receive(.loginResponse(.success(AuthDataResult()))) {
////                $0.uid = ""
////                $0.isSignedIn = true
////                $0.alertText = "Successfully signed in!"
////            }
//
//
//    }
    
}
