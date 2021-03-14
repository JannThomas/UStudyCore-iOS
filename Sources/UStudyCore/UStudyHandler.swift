//
//  UStudyHandler.swift
//  Banking
//
//  Created by Jann Schafranek on 23.01.19.
//  Copyright © 2019 Jann Thomas. All rights reserved.
//

import Foundation
import JavaScriptCore
import SchafKit
import CoreLocation

public let handler = UStudyHandler.shared

public class UStudyHandler: ObservableObject {
    public static let shared = UStudyHandler()
    
    #if os(macOS)
    let ustudyDirectory = OKDirectory(url: Constants.coreBundle.bundleURL).directoryByAppending(path: "Contents/Resources/Core")
    let unisDirectory = OKDirectory(url: Constants.coreBundle.bundleURL).directoryByAppending(path: "Contents/Resources/Core/Payloads")
    #else
    let ustudyDirectory = OKDirectory(url: Constants.coreBundle.bundleURL).directoryByAppending(path: "Core")
    let unisDirectory = OKDirectory(url: Constants.coreBundle.bundleURL).directoryByAppending(path: "Core/Payloads")
    #endif
    
    var accounts: [Account]
    var currentAccount: Account? {
        willSet { currentAccount?.isActive = false }
        didSet { currentAccount?.isActive = true }
    }
    
    public var unis: [University]
    
    private init() {
        accounts = dataHandler.getObjects(ofType: Account.self) ?? []
        currentAccount = accounts.filter { (account) -> Bool in return account.isActive }.first
        
        unis = [] // TODO: try! JSONDecoder().decode([University].self, from: unisDirectory.getData(at: Constants.mainPayloadName)!)
    }
    
    public func retrieveUniversities(path: String) {
        var unis: [University] = []
        
        let dir = OKDirectory(path: path)
        for country in dir.contents {
            let cDir = dir.directoryByAppending(path: country)
            for uniDir in cDir.contents {
                guard let data = cDir.directoryByAppending(path: uniDir).getData(at: Constants.mainPayloadName),
                    let uni = try? JSONDecoder().decode(University.self, from: data) else {
                        print("Could not get main payload: \(uniDir)")
                    continue
                }
                
                unis.append(uni)
            }
        }
        
        self.unis = unis
    }
}
