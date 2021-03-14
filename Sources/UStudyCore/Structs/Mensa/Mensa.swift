//
//  Mensa.swift
//  UStudy
//
//  Created by Jann Schafranek on 09.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import CoreLocation

public struct Mensa: Codable {
    
    public struct Info: Codable {
        public let name: String
        public let text: String?
    }
    
    public struct Availability: Codable {
        public let start: Date?
        public let end: Date?
    }
    
    public let id: String
    public let name: String
    public let icon: String?
    
    public let location: CLLocationCoordinate2D
    
    public let additionalInfos : [Info]
    
    public let availability: Availability?
}
