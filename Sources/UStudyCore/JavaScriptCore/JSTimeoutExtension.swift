//
//  JSTimeoutExtension.swift
//  Standard Project
//
//  Created by Jann Schafranek on 16.12.18.
//  Copyright © 2018 Jann Thomas. All rights reserved.
//

import SchafKit
import JavaScriptCore

class JSTimeoutExtension {
    static let shared = JSTimeoutExtension()
    
    private var timers : [Int : Timer] = [:]
    
    func addTimer(isInterval : Bool, arguments : [JSValue]) -> Int {
        let hash = NSUUID().hashValue
        
        guard let function = arguments[ifExists: 0],
            let interval = arguments[ifExists: 1]?.toDouble() else {
                return -1
        }
        
        let timer = Timer.scheduledTimer(withTimeInterval: interval / 1000, repeats: isInterval, block: { (timer) in
            function.call(withArguments: Array(arguments[2..<arguments.count]))
            
            if !isInterval {
                self.timers[hash] = nil
            }
        })
        
        timers[hash] = timer
        
        return hash
    }
    
    func removeTimer(argument : JSValue) {
        let hash = Int(argument.toInt32())
        
        timers[hash]?.invalidate()
        timers[hash] = nil
    }
    
    func add (to context: JSContext) {
        let setTimeout: @convention(block) (Any) -> Int = { arguments in
            return self.addTimer(isInterval: false, arguments: JSContext.currentArguments() as? [JSValue] ?? [])
        }
        context["setTimeout"] = setTimeout
        
        let setInterval: @convention(block) (Any) -> Int = { arguments in
            return self.addTimer(isInterval: true, arguments: JSContext.currentArguments() as? [JSValue] ?? [])
        }
        context["setInterval"] = setInterval
        
        let clearInterval: @convention(block) (JSValue) -> Void = { argument in
            return self.removeTimer(argument: argument)
        }
        context["clearInterval"] = clearInterval
        context["clearTimeout"] = clearInterval
    }
}
