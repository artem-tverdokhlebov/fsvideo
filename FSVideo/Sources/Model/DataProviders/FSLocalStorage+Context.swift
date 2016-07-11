//
//  FSLocalStorage+Context.swift
//
//  Created by Alexey Bodnya on 04/11/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


extension FSLocalStorage {
    
    func saveChanges() {
        do {
            try self.mainObjectContext.save()
        } catch let error as NSError {
            print("Fail save: " + error.description)
        }
    }
    
    func saveChanges(context: NSManagedObjectContext) {
        if context != self.inMemoryObjectContext {
            if context != self.mainObjectContext {
                NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(contextDidSaved(_:)), name: NSManagedObjectContextDidSaveNotification, object: context)
            }
            do {
                try context.save()
            } catch let error as NSError {
                print("Fail background save: " + error.description)
            }
            if context != self.mainObjectContext {
                NSNotificationCenter.defaultCenter().removeObserver(self, name: NSManagedObjectContextDidSaveNotification, object: context)
            }
        }
    }
    
    func contextDidSaved(notification: NSNotification) {
        self.mainObjectContext.performBlock {
            self.mainObjectContext.mergeChangesFromContextDidSaveNotification(notification)
            self.saveChanges()
        }
    }
    
    func createContext(response: (context: NSManagedObjectContext!) -> ()) {
        self.asyncQueue.addOperationWithBlock {
            let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
            context.persistentStoreCoordinator = self.persistentStoreCoordinator
            self.asyncContexts.append(context)
            response(context: context)
        }
    }
    
    func removeContext(context: NSManagedObjectContext!) {
        if context != self.mainObjectContext {
            if let index = self.asyncContexts.indexOf(context) {
                self.asyncContexts.removeAtIndex(index)
            }
        }
    }
}
