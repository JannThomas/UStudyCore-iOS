//
//  AutosavingManagedObject.swift
//  UStudy
//
//  Created by Jann Schafranek on 25.01.19.
//  Copyright © 2019 Jann Thomas. All rights reserved.
//

import CoreData

public class AutosavingManagedObject : NSManagedObject {
    override public func didChangeValue(forKey key: String) {
        super.didChangeValue(forKey: key)
        
        if self.hasChanges {
            dataHandler.scheduleSave()
        }
    }
}
