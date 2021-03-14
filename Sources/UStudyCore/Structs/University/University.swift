//
//  University.swift
//  UStudy
//
//  Created by Jann Schafranek on 06.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import CoreLocation

public struct University: Codable {
    public var id : String
    
    public var name : String
    public var tags : [String]
    public var city : String
    public var location : CLLocationCoordinate2D
    
    public var authors : [Author]?
    
    public var userGroups : [UserGroup]?
    
    public init(id: String, name: String, tags: [String], city: String, location: CLLocationCoordinate2D, authors: [Author]?, userGroups: [UserGroup]?) {
        self.id = id
        self.name = name
        self.tags = tags
        self.city = city
        self.location = location
        self.authors = authors
        self.userGroups = userGroups
    }
}
