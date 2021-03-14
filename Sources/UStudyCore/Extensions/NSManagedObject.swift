//  Copyright (c) 2015 - 2018 Jann Schafranek
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if canImport(CoreData)
import CoreData

public extension NSManagedObject {
    /// Returns the `NSManagedObjectContext` of the receiver.
    var context : NSManagedObjectContext?{
        return managedObjectContext
    }
    
    /**
     Deletes the receiver from its `NSManagedObjectContext`.
    
     - Note : This automatically saves the containing managedObjectContext after deletion.
    */
    func delete () {
        guard let context = managedObjectContext else {
            return
        }
        
        context.delete(self)
        save()
    }
    
    /// Asynchronously performs a block on the queue of the `NSManagedObjectContext` of the receiver.
    func performBlock(_ block: @escaping () -> Void){
        context?.perform(block)
    }
    
    /// Synchronously performs a block on the queue of the `NSManagedObjectContext` of the receiver.
    func performBlockAndWait(_ block: @escaping () -> Void){
        context?.performAndWait(block)
    }
    
    /// Saves the receivers context.
    func save () {
        guard let context = context else {
            print("Error : Tried to save contextless NSManagedObject:", self)
            return
        }
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

#endif
