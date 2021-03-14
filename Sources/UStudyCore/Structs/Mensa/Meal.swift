//
//  Meal.swift
//  UStudy
//
//  Created by Jann Schafranek on 06.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation

public struct Meal: Codable {
    
    public let name: String
    public let subtitle: String
    public let group: String?
    
    public let imageUrl: String?
    public let imageUrlBig: String?
    
    public let prices: [String: String]
    
    public let mensa: String
}
