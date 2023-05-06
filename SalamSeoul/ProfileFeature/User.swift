//
//  User.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/29.
//

import Foundation

struct User: Equatable {
    var email: String
    var password: String
    var userName: String
    var isPro: Bool
}

extension User {
  func toFirestoreData() -> [String: Any] {
    return [
      "email": self.email,
      "password": self.password,
      "userName": self.userName,
      "isPro": self.isPro
    ]
  }
}
