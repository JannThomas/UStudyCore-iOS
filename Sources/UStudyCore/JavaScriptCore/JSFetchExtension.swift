//
//  JSFetchExtension.swift
//  Standard Project
//
//  Created by Jann Schafranek on 18.12.18.
//  Copyright © 2018 Jann Thomas. All rights reserved.
//

import JavaScriptCore
import SchafKit

class JSFetchExtension {
    static let shared = JSFetchExtension()
    
    private let _fetch : @convention(block) (String, [String : Any]) -> Any = { url, configuration in
        let promiseBlockName = "PromiseBlockBridge"
        guard let context = JSContext.current(),
            let promiseType = context.evaluateScript("Promise") else {
                return String.empty
        }
        
        let promiseBlock: @convention(block) (JSValue, JSValue) -> Void = { thenFunction, catchFunction in
            let rawMethod = configuration["method"] as? String ?? .empty
            let method = OKNetworking.Request.Method(rawValue: rawMethod.uppercased()) ?? .get
            
            let headers = (configuration["headers"] as? [String : String] ?? [:]).reduce(into: [OKNetworking.Request.HeaderField : String](), { (result, kVP) in
                result[OKNetworking.Request.HeaderField(stringLiteral: kVP.key)] = kVP.value
            })
            
            var options : OKOptionSet<OKNetworking.Request.Options> = [
                .requestMethod(value: method),
                .headerFields(value: headers)
            ]
            
            if let body = configuration["body"] as? String {
                options += .body(value: .raw(value: body, type: .empty))
            }
            
            let wasMainThread = Thread.isMainThread
            OKNetworking.request(url: url, options: options, completion: { (result) in
                let block = {
                    guard case .success(let value) = result else {
                        let errorText = result.failureValue?.localizedDescription ?? "Error"
                        let errorObject = context.evaluateScript("new Error(\"\(errorText)\");")!
                        catchFunction.call(withArguments: [errorObject])
                        print("urlNOW:", url)
                        return
                    }
                    
                    let headersType = context.evaluateScript("Headers")!
                    let responseType = context.evaluateScript("Response")!
                    
                    let statusCode = value.response.statusCode ?? -1
                    let bodyString = value.stringValue ?? .empty
                    
                    let headerDictionary = (value.response.response as? HTTPURLResponse)?.allHeaderFields ?? [:]
                    let headers = headersType.construct(withArguments: [headerDictionary])!
                    
                    let response = responseType.construct(withArguments: [url, headers, false, statusCode, bodyString])!
                    
                    thenFunction.call(withArguments: [response])
                }
                
                if wasMainThread {
                    block()
                } else {
                    OKDispatchHelper.dispatchUserInitiatedTask(block: block)
                }
            })
        }
        
        context[promiseBlockName] = promiseBlock
        let promiseBlockValue : JSValue = context[promiseBlockName]
        let promise : JSValue = promiseType.construct(withArguments: [promiseBlockValue])
        context[promiseBlockName] = JSValue(nullIn: context) as Any
        
        return promise
    }
    
    func add (to context: JSContext) {
        let polyFillURL = Constants.coreBundle.url(forResource: "JSFetchExtension", withExtension: "js")!
        let polyFillScript = try! String(contentsOf: polyFillURL)
        context.evaluateScript(polyFillScript)
        
        context["fetch"] = _fetch
    }
}
