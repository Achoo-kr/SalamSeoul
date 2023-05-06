//
//  Restaurant.swift
//  SalamSeoul
//
//  Created by 추현호 on 2023/04/26.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

public struct Restaurant: Hashable, Equatable, Codable {
    public let address: String
    public let category: String
    public let certifiedState: String
    public let name: String
    public let phoneNumber: String
    public let website: String
    
    public init(address: String = "",
                category: String = "",
                certifiedState: String = "",
                name: String = "",
                phoneNumber: String = "",
                website: String = "") {
        self.address = address
        self.category = category
        self.certifiedState = certifiedState
        self.name = name
        self.phoneNumber = phoneNumber
        self.website = website
    }
}
