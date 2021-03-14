//
//  JavaScriptError.swift
//  UStudyCore
//
//  Created by Jann Schafranek on 18.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import JavaScriptCore

public struct JavaScriptError: Error, CustomStringConvertible {
    public let value: JSValue
    
    public init(_ error: JSValue) {
        self.value = error
    }
    
    public var description: String {
        return localizedDescription
    }
}
