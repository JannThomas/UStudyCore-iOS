//
//  StoredData.swift
//  UStudy
//
//  Created by Jann Schafranek on 11.02.20.
//  Copyright © 2020 Jann Thomas. All rights reserved.
//

import Foundation
import CoreData

@objc(StoredData)
public class StoredData: AutosavingManagedObject {
    convenience init(key : String, data : Data, account : Account, context : NSManagedObjectContext?) {
        self.init(context: context ?? viewContext)
        
        self.key = key
        self.data = data
        self.account = account
    }
}
