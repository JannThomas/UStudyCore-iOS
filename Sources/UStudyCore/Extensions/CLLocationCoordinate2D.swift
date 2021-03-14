//
//  CLLocationCoordinate2D.swift
//  UStudy
//
//  Created by Jann Schafranek on 09.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Codable {
    
    private enum CodingKeys: String, CodingKey {
        case latitude, longitude
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init()
        
        self.latitude = try container.decode(CLLocationDegrees.self, forKey: .latitude)
        self.longitude = try container.decode(CLLocationDegrees.self, forKey: .longitude)
    }
}
