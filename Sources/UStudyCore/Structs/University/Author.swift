//
//  Author.swift
//  UStudy
//
//  Created by Jann Schafranek on 06.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation

public struct Author: Codable {
    
    public struct ContactOption: Codable, Identifiable {
        
        public var id: String {
            return serviceName
        }
        
        public var serviceName: String
        public var serviceImageUrl: String
        public var url: String
        
        public init(serviceName: String, serviceImageUrl: String, url: String) {
            self.serviceName = serviceName
            self.serviceImageUrl = serviceImageUrl
            self.url = url
        }
    }
    
    public var name: String
    public var imageUrl: String?
    
    public var contactOptions: [ContactOption]
    
    public init(name: String, imageUrl: String?, contactOptions: [Author.ContactOption]) {
        self.name = name
        self.imageUrl = imageUrl
        self.contactOptions = contactOptions
    }
}
