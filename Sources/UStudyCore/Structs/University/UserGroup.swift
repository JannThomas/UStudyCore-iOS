//
//  UserGroup.swift
//  UStudy
//
//  Created by Jann Schafranek on 11.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation

public struct UserGroup: Codable {
    public var id: String
    public var name: String
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
