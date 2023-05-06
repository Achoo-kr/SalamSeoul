//
//  FirebaseAuthClient.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import ComposableArchitecture
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import CryptoKit
import AuthenticationServices

struct FirebaseAuthClient {
    static let users = "Users"
    var signUpWithEmail: (_ email: String, _ password: String) -> Effect<AuthDataResult, ApiFailure>
    var signInWithEmail: (_ email: String, _ password: String) -> Effect<AuthDataResult, ApiFailure>
    var randomNonceString: () -> String
    var sha256: (_ input: String) -> String
    var authenticate: (_ credential: ASAuthorizationAppleIDCredential, _ nonce: String) -> Void
    
    var signOut: () -> Void
    var deleteAccount: () -> Void
    
    struct ApiFailure: Error, Equatable {
        public let message: String
        
        public init(message: String) {
            self.message = message
        }
    }
    
    init(signUpWithEmail: @escaping (_ email: String, _ password: String) -> Effect<AuthDataResult, ApiFailure>,
         signInWithEmail: @escaping (_ email: String, _ password: String) -> Effect<AuthDataResult, ApiFailure>,
         randomNonceString: @escaping () -> String,
         sha256: @escaping (_ input: String) -> String,
         authenticate: @escaping (_ credential: ASAuthorizationAppleIDCredential, _ nonce: String) -> Void,
         signOut: @escaping () -> Void,
         deleteAccount: @escaping () -> Void) {
        self.signUpWithEmail = signUpWithEmail
        self.signInWithEmail = signInWithEmail
        self.sha256 = sha256
        self.signOut = signOut
        self.deleteAccount = deleteAccount
        self.randomNonceString = randomNonceString
        self.authenticate = authenticate
    }
    
    
}

//.future { callback in }은 Swift의 Future 타입을 생성하는 메서드입니다.
//Future는 비동기 작업을 표현하는 타입으로, 특정 작업이 완료되면 결과값을 반환합니다. .future { callback in } 메서드는 Future를 생성하기 위해 클로저를 받습니다. 클로저 내부에서는 비동기 작업을 수행하고, 작업이 완료될 때 callback 클로저를 호출하여 Future의 결과값을 반환합니다.
//
//callback 클로저는 두 개의 매개변수를 받습니다. 첫 번째 매개변수는 작업이 성공적으로 완료되었을 때 결과값을 전달하는 Result 타입의 값입니다. 두 번째 매개변수는 작업이 실패했을 때 발생한 오류를 전달하는 Error 타입의 값입니다.
//
//따라서 .future { callback in }은 비동기 작업을 수행하고, 작업이 완료되면 결과값을 반환하는 Future를 생성하는 메서드입니다.

extension FirebaseAuthClient {
    static let live = Self(
        signUpWithEmail: { email, password in
                .future { callback in
                    // 이미 등록된 이메일
                    let usersCollection = Firestore.firestore().collection(Self.users)
                    let query = usersCollection.whereField("email", isEqualTo: email)
                    query.getDocuments { snapshot, error in
                        guard error == nil else {
                            callback(.failure(ApiFailure(message: error!.localizedDescription)))
                            return
                        }
                        
                        guard snapshot?.documents.count == 0 else {
                            callback(.failure(ApiFailure(message: "This email is already registered.")))
                            return
                        }
                        
                        // 중복되지 않은 이메일
                        Auth.auth().createUser(withEmail: email, password: password) { result, error in
                            if let error = error {
                                callback(.failure(ApiFailure(message: error.localizedDescription)))
                                return
                            }
                            
                            guard let authDataResult = result else {
                                callback(.failure(ApiFailure(message: "Failed to create user.")))
                                return
                            }
                            
                            let user = User(email: email, password: password, userName: "", isPro: false)
                            usersCollection.document(authDataResult.user.uid).setData(user.toFirestoreData()) { error in
                                if let error = error {
                                    callback(.failure(ApiFailure(message: error.localizedDescription)))
                                    return
                                }
                                
                                callback(.success(authDataResult))
                            }
                        }
                    }
                }
        },
        signInWithEmail: { email, password in
                .future { callback in
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        if let error = error {
                            callback(.failure(ApiFailure(message: error.localizedDescription)))
                            return
                        }
                        
                        guard let authDataResult = result else {
                            callback(.failure(ApiFailure(message: "Failed to sign in.")))
                            return
                        }
                        callback(.success(authDataResult))
                    }
                }
        },
        randomNonceString: {
                var length: Int = 32
                precondition(length > 0)
                var randomBytes = [UInt8](repeating: 0, count: length)
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                
                let charset: [Character] =
                Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
                
                let nonce = randomBytes.map { byte in
                    // Pick a random character from the set, wrapping around if needed.
                    charset[Int(byte) % charset.count]
                }
                
                return String(nonce)
        },
        sha256: { input in
            let inputData = Data(input.utf8)
            let hashedData = SHA256.hash(data: inputData)
            let hashString = hashedData.compactMap {
                String(format: "%02x", $0)
            }.joined()

            return hashString
        },
        authenticate: { credential, nonce in
                    guard let token = credential.identityToken else {
                        print("error with firebase")
                        
                        return
                    }
                    
                    guard let tokenString = String(data: token, encoding: .utf8) else {
                        print("error with Token")
                        return
                    }
                    
                    let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
                    
                    Auth.auth().signIn(with: firebaseCredential)
        },
        signOut: {
            try? Auth.auth().signOut()
        },
        deleteAccount: {
            if let currentUser = Auth.auth().currentUser {
                let usersCollection = Firestore.firestore().collection(Self.users)
                usersCollection.document(currentUser.uid).delete { error in
                    if let error = error {
                        print("Failed to delete user document: \(error.localizedDescription)")
                    }
                }
                
                currentUser.delete { error in
                    if let error = error {
                        print("Failed to delete user: \(error.localizedDescription)")
                    }
                }
            }
        }
    )
}
