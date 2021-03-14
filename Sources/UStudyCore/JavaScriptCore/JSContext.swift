//
//  JSContext.swift
//  Standard Project
//
//  Created by Jann Schafranek on 16.12.18.
//  Copyright © 2018 Jann Thomas. All rights reserved.
//

import JavaScriptCore

extension JSContext {
    subscript (string : String) -> JSValue {
        get {
            return self.objectForKeyedSubscript(string)
        }
    }
    
    subscript (string : String) -> Any {
        get {
            return self.objectForKeyedSubscript(string) as Any
        }
        set {
            self.setObject(newValue, forKeyedSubscript: string as (NSCopying & NSObjectProtocol))
        }
    }
    
    func add (_ ext : JSContextExtension) {
        ext.add(to: self)
    }
    
    func addAllExtensions () {
        for ext in JSContextExtension.allCases {
            ext.add(to: self)
        }
    }
    
    func evaluateScript(at url : URL) throws -> JSValue {
        return try self.evaluateScript(String(contentsOf: url))
    }
}

extension JSValue {
    subscript (string : String) -> JSValue {
        get {
            return self.objectForKeyedSubscript(string)
        }
    }
    
    subscript (string : String) -> Any {
        get {
            return self.objectForKeyedSubscript(string) as Any
        }
        set {
            self.setObject(newValue, forKeyedSubscript: string as (NSCopying & NSObjectProtocol))
        }
    }
}
