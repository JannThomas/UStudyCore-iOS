//
//  LoginCredential+CoreDataClass.swift
//  Banking
//
//  Created by Jann Schafranek on 24.01.19.
//  Copyright © 2019 Jann Thomas. All rights reserved.
//
//

import Foundation
import CoreData

@objc(LoginCredential)
public class LoginCredential: AutosavingManagedObject {
    convenience init(id : String, value : String, account : Account, context : NSManagedObjectContext?) {
        self.init(context: context ?? viewContext)
        
        self.id = id
        self.value = value
        self.account = account
    }
}
