//
//  FirebaseApiClient.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/26.
//

import Combine
import ComposableArchitecture
import Firebase
import FirebaseFirestoreSwift

public struct FirebaseApiClient {
    private static let restaurants = "Restaurants"
    public var updateSnapshot: () -> Effect<[Restaurant], ApiFailure>
    
    public struct ApiFailure: Error, Equatable {
        public let message: String
        
        public init(message: String) {
            self.message = message
        }
    }
    
    public init(updateSnapshot: @escaping () -> Effect<[Restaurant], ApiFailure>) {
        self.updateSnapshot = updateSnapshot
    }
}

//live를 이용한 코드 - live : naming convention으로 해당 모델이나 서비스를 실행하는데 필요한 모든 환경이 구성되어 있어서 라이브로 사용할 수 있다는 뜻
public extension FirebaseApiClient {
    static let live = Self {
        .run { subscriber in
            let listenerRegistration = Firestore.firestore().collection(Self.restaurants).addSnapshotListener { snapshot, error in
                print("update snapshot")
                if let error = error {
                    subscriber.send(
                        completion: .failure(
                            .init(message: error.localizedDescription)
                        )
                    )
                }
                guard let documents = snapshot?.documents else {
                    subscriber.send(
                        completion: .failure(
                            .init(message: "Snapshot is nil.")
                        )
                    )
                    return
                }
                var restaurants: [Restaurant] = []
                documents.forEach { content in
                    do {
                        var restaurant = try Firestore.Decoder().decode(Restaurant.self, from: content.data())
                        // 명시적으로 대입하지 않으면 nil이 된다
                        restaurants.append(restaurant)
                    } catch {
                        subscriber.send(
                            completion: .failure(
                                .init(message: error.localizedDescription)
                            )
                        )
                    }
                }
                subscriber.send(restaurants)
            }
            return AnyCancellable {
                print("cancel")
                listenerRegistration.remove()
            }
        }
    }
}

public extension FirebaseApiClient {
    static let mock = FirebaseApiClient {
        .run { subscriber in
            subscriber.send([
                Restaurant(address: "Seoul",
                           category: "Turkish food",
                           name: "SalamSeoul"),
                Restaurant(address: "Seoul",
                           category: "Turkish food",
                           name: "Choo Kebab"),
                Restaurant(address: "Seoul",
                           category: "Turkish food",
                           name: "Hyunho Kebab"),
            ])
            return AnyCancellable {}
        }
    }
}
