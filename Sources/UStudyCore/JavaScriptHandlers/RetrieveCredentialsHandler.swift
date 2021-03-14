//
//  requireInputs.swift
//  Standard Project
//
//  Created by Jann Schafranek on 20.01.19.
//  Copyright © 2019 Jann Thomas. All rights reserved.
//

import SchafKit
import JavaScriptCore

protocol JavaScriptHandler {
    func add(to context : JSContext)
}

public class RetrieveCredentialsHandler : JavaScriptHandler {
    public static let shared = RetrieveCredentialsHandler()
    public var errorHandler: ((Error) -> Void)?
    
    func requireInputs(_ configuration : JSCredentialRetrievementConfiguration, completionHandler : JSValue) {
        var returnDictionary : [String : String] = [:]
        
        let account : Account?
        if let accountId = configuration.account {
            account = dataHandler.getObject(withType: Account.self, id: accountId)
        } else {
            account = nil
        }
        
        let requirements = configuration.requirements
        var textFields : [OKAlerting.TextFieldConfiguration] = []
        
        var hasUnfulfilledRequirements : Bool = false
        var requirementsWithOptions: [JSCredentialRequirement] = []
        
        // Retrieve credentials and add text fields for all requirements
        for requirement in requirements {
            let credential = account?.credential(for: requirement.id)
            returnDictionary[requirement.id] = credential
            
            if requirement.options?.count ?? 0 > 0 {
                requirementsWithOptions.append(requirement)
                continue
            } else if (requirement.isUserEnterable != false) {
                let field = OKAlerting.TextFieldConfiguration(placeholder: requirement.type ?? .empty, // TODO: Map
                    text: (requirement.shouldSave != false) ? credential : nil,
                    isPassword: requirement.isPassword == true)
                textFields.append(field)
            }
            
            let isUnfulfilled = (credential == nil) && (requirement.isUserEnterable != false)
            hasUnfulfilledRequirements = hasUnfulfilledRequirements || isUnfulfilled
        }
        
        var handler: ()->Void = {}
        
        handler = {
            // Check for requirements with options
            if let requirement = requirementsWithOptions.removeFirstIfExists() {
                let requirementId = requirement.id
                let actions : [OKAlerting.Action] = (requirement.options ?? []).map({ (value) -> OKAlerting.Action in
                    return OKAlerting.Action(title: value, style: .default, handler: { (_, _) in
                        
                        if let account = account, requirement.shouldSave == true {
                            account.setCredential(id: requirementId, value: value)
                        }
                        returnDictionary[requirementId] = value
                        
                        handler()
                    })
                })
                
                OKAlerting.showAlert(title: "Choose " + (requirement.type ?? ""),
                                     showOKAction: false,
                                     showCancelAction: false,
                                     additionalActions: actions,
                                     preferredStyle: .actionSheet)
                return
            }
            
            // Check whether all fields are already saved
            if !hasUnfulfilledRequirements {
                completionHandler.call(withArguments: [returnDictionary])
                return
            }
            
            let completion : OKAlerting.Action.Block  = { (_, values) in
                for i in 0..<requirements.count {
                    let requirement = requirements[i]
                    let requirementId = requirement.id
                    let value = values[i]
                    
                    if let account = account, requirement.shouldSave == true {
                        account.setCredential(id: requirementId, value: value)
                    }
                    
                    returnDictionary[requirementId] = value
                }
                
                completionHandler.call(withArguments: [returnDictionary])
            }

            OKAlerting.showPrompt(title: configuration.type,
                                     textFieldConfigurations: textFields,
                                     completion: completion,
                                     cancellation: {
                                        // TODO: Descide what to do here
            })
        }
        
        handler()
    }
    
    func setInputs(_ configuration : JSCredentialSetterConfiguration) {
        let account : Account?
        if let accountId = configuration.account {
            account = dataHandler.getObject(withType: Account.self, id: accountId)
        } else {
            account = nil
        }
        
        for credential in configuration.credentials {
            account?.setCredential(id: credential.key, value: credential.value)
        }
    }
    
    func add(to context: JSContext) {
        let retrieveCredentials: @convention(block) (Any) -> Void = { arguments in
            let currentArguments = JSContext.currentArguments() as? [JSValue] ?? []
            guard let encodedConfiguration = currentArguments[ifExists: 0]?.toDictionary(),
                let completionHandler = currentArguments[ifExists: 1] else {
                print("Error: configuration strange error")
                return
            }
            
            do {
                let configuration = try GenericDecoder().decode(JSCredentialRetrievementConfiguration.self, from: encodedConfiguration)
                self.requireInputs(configuration, completionHandler: completionHandler)
            }
            catch(let error) {
                print("Error loading retrievement configuration: \(error)")
                self.errorHandler?(error)
            }
        }
        
        let setCredentials: @convention(block) (Any) -> Void = { arguments in
            let currentArguments = JSContext.currentArguments() as? [JSValue] ?? []
            guard let encodedConfiguration = currentArguments[ifExists: 0]?.toDictionary() else {
                    print("Error: credential setter configuration is not a dictionary")
                    return
            }
            
            do {
                let configuration = try GenericDecoder().decode(JSCredentialSetterConfiguration.self, from: encodedConfiguration)
                self.setInputs(configuration)
            }
            catch(let error) {
                print("Error loading setter configuration: \(error)")
                self.errorHandler?(error)
            }
        }
        
        context["retrieveCredentials"] = retrieveCredentials
        context["setCredentials"] = setCredentials
    }
}

struct JSCredentialRetrievementConfiguration : Codable {
    let account : String?
    
    let type : String?
    let requirements : [JSCredentialRequirement]
}

struct JSCredentialRequirement : Codable {
    let id : String
    let type : String?
    let shouldSave : Bool?
    let isPassword : Bool?
    let isUserEnterable : Bool?
    
    /// Options to be able to choose from.
    let options: [String]?
}

struct JSCredentialSetterConfiguration : Codable {
    let account : String?
    
    let credentials : [String : String?]
}
