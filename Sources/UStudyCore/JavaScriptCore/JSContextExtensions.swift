//
//  JSContextExtension.swift
//  Standard Project
//
//  Created by Jann Schafranek on 16.12.18.
//  Copyright © 2018 Jann Thomas. All rights reserved.
//

import JavaScriptCore
import SchafKit

private let _consoleLog : @convention(block) (String) -> Void = { input in
    print("JS:", input)
}

enum JSContextExtension : CaseIterable {
    case fetch, consoleLog, timeoutAndInterval
    
    private var block : Any {
        switch self {
        case .consoleLog:
            return _consoleLog
        default:
            fatalError()
        }
    }
    
    private var path : [String] {
        switch self {
        case .consoleLog:
            return ["console", "log"]
        default:
            fatalError()
        }
    }
    
    func add (to context: JSContext) {
        switch self {
        // TODO: Make Generic
        case .timeoutAndInterval:
            JSTimeoutExtension.shared.add(to: context)
            return
        case .fetch:
            JSFetchExtension.shared.add(to: context)
            return
        default:
            break
        }
        
        var path = self.path
        var next = path.removeFirst()
        
        var value : JSValue
        
        if path.isEmpty {
            context[next] = block
            return
        } else {
            value = context[next]
        }
        
        next = path.removeFirst()
        while !path.isEmpty {
            value = value[next]
            
            next = path.removeFirst()
        }
        
        value[next] = block
    }
}
