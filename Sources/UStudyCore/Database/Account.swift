//
//  Account+CoreDataClass.swift
//  Banking
//
//  Created by Jann Schafranek on 24.01.19.
//  Copyright © 2019 Jann Thomas. All rights reserved.
//
//

import Foundation
import JavaScriptCore
import CoreData
import SchafKit

@objc(Account)
public class Account : AutosavingManagedObject {
    public var overrideFolderURL: URL?
    public var errorHandler: ((Error) -> Void)?
    
    // - MARK: Variables
    
    lazy var jsContext : JSContext = {
        let jsContext = JSContext()!
        
        jsContext.exceptionHandler = handleException
        jsContext.name = self.id
        
        // Add all extensions (fetch, interval, console)
        jsContext.addAllExtensions()
        // Add credential retriever
        RetrieveCredentialsHandler.shared.add(to: jsContext)
        // Add ability to include relative files
        addInclude(to: jsContext)
        // Add ability to set an account name
        addSetAccountName(to: jsContext)
        // Add npm modules
        _ = try! jsContext.evaluateScript(at: Constants.modulesURL)
        // Add extensions.js
        _ = try! jsContext.evaluateScript(at: handler.ustudyDirectory.url.appendingPathComponent(Constants.extensionsFileName))
        
        return jsContext
    }()
    
    lazy var folderURL : URL = {
        if let overrideFolderURL = overrideFolderURL {
            return overrideFolderURL
        }
        let pathComponent = type!
        return handler.unisDirectory.url.appendingPathComponent(pathComponent)
    }()
    
    public lazy var uniValue : JSValue = {
        // URL of the main.js file
        let url = folderURL.appendingPathComponent(Constants.mainScriptName)
        do {
            // execute main.js and retrieve university type
            let uniValueType = try jsContext.evaluateScript(at: url)
            // initialize instance of university type
            let uniValue = uniValueType.construct(withArguments: [self.id!])
            
            return uniValue!
        }
        catch(let error) {
            if let errorHandler = errorHandler {
                errorHandler(error)
            } else {
                fatalError(error.localizedDescription)
            }
        }
        
        return JSValue()
    }()
    
    public lazy var university: University = {
        let uni = try! JSONDecoder().decode(University.self, from: try! Data(contentsOf: folderURL.appendingPathComponent(Constants.mainPayloadName)))
        
        return uni
    }()
    
    private var userGroupKey: String { "\(self.type ?? "")-UserGroup" }
    public var selectedUserGroup: String {
        get { UserDefaults.standard.string(forKey: userGroupKey) ?? university.userGroups?.first?.id ?? "-" }
        set { UserDefaults.standard.set(newValue, forKey: userGroupKey) }
    }
    
    // - MARK: Initializers
    
    public convenience init(name: String = .empty, type: String, context : NSManagedObjectContext = viewContext) {
        self.init(context: context)
        
        self.id = UUID().uuidString
        self.name = name
        self.type = type
    }
    
    // - MARK: JavaScriptCore Handlers
    
    private func handleException(context : JSContext?, exception : JSValue?) {
        if let exception = exception {
            errorHandler?(GenericError(exception.description))
        }
        print("JS Exception:", exception as Any)
    }
    
    // - MARK: Include Files
    
    func addInclude(to context: JSContext) {
        let folderURL = self.folderURL
        
        context["include"] = { pathComponent in
            let url = folderURL.appendingPathComponent(pathComponent)
            _ = try! context.evaluateScript(at: url)
        } as (@convention(block) (String) -> Void)
    }
    
    // - MARK: Include Files
    
    func addSetAccountName(to context: JSContext) {
        context["setAccountName"] = { newName in
            self.name = newName
        } as (@convention(block) (String) -> Void)
    }
    
    // - MARK: Mensa
    
    private func completionBlock<T: Decodable>(_ type: T.Type, completionHandler: @escaping (Result<T, Error>) -> Void) -> JSValue {
        let block : @convention(block) (Any) -> Void = { returnValue in
            self.decode(type, from: returnValue, completionHandler: completionHandler)
        }
        return JSValue(object: block, in: jsContext)!
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from value: Any, completionHandler: @escaping (Result<T, Error>) -> Void) {
        if let err = value as? String {
            completionHandler(.failure(GenericError(err)))
            return
        }
        
        do {
            let result = try GenericDecoder().decode(type, from: value)
            completionHandler(.success(result))
        }
        catch let error {
            print("Error while decoding \(type):", error)
            completionHandler(.failure(error))
        }
    }
    
    public func getMensas(completionHandler: @escaping (Result<[Mensa], Error>) -> Void) {
        let completion = completionBlock([Mensa].self, completionHandler: completionHandler)
        
        uniValue.invokeMethod("getMensas", withArguments: [completion])
    }
    
    public func getMensaMeals(mensaIds: [String]? = nil, date: Date, completionHandler: @escaping (Result<[Meal], Error>) -> Void) {
        let completion = completionBlock([Meal].self, completionHandler: completionHandler)
        
        uniValue.invokeMethod("getMensaFood", withArguments: [mensaIds as Any, date, completion])
    }
    
    // - MARK: Grades
    
    public func getGrades(completionHandler: @escaping (Result<[Grade], Error>) -> Void) {
        let completion = completionBlock([Grade].self, completionHandler: completionHandler)
        
        uniValue.invokeMethod("getGrades", withArguments: [completion])
    }
    
    // - MARK: Credentials
    
    private func getCredential(for id : String) -> LoginCredential? {
        for credential in credentials ?? [] {
            let credential =  credential as! LoginCredential
            if credential.id == id {
                return credential
            }
        }
        
        return nil
    }
    
    public func credential(for id : String) -> String? {
        return getCredential(for: id)?.value
    }
    
    internal func setCredential(id : String, value : String?) {
        // Check if the credential already exists
        if let credential = getCredential(for: id) {
            // Delete if the new value is nil
            if value == nil {
                credential.delete()
                return
            }
            // Update it's value
            credential.value = value
            return
        }
        
        guard let value = value else {
            return
        }
        
        // Add a new one if it doesn't already exist
        _ = LoginCredential(id: id, value: value, account: self, context: self.context)
    }
    
    // - MARK: Stored Data
    
    private func getData(for key : String) -> StoredData? {
        for data in data ?? [] {
            let data =  data as! StoredData
            if data.key == key {
                return data
            }
        }
        
        return nil
    }
    
    public func data(for id : String) -> Data? {
        return getData(for: id)?.data
    }
    
    public func setData(key : String, newData : Data?) {
        
        // Check if the credential already exists
        if let data = getData(for: key) {
            // Delete if the new value is nil
            if newData == nil {
                data.delete()
                return
            }
            
            // Update it's value
            data.data = newData
            return
        }
        
        guard let newData = newData else {
            return
        }
        
        // Add a new one if it doesn't already exist
        _ = StoredData(key: key, data: newData, account: self, context: self.context)
    }
}
