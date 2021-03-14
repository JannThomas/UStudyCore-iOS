//
//  GenericError.swift
//  UStudyCore
//
//  Created by Jann Schafranek on 18.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation

public struct GenericError: Error, CustomStringConvertible {
    public let localizedDescription: String
    
    public init(_ localizedDescription: String) {
        self.localizedDescription = localizedDescription
    }
    
    public var description: String {
        return localizedDescription
    }
}
