//
//  FSLocalStorage+Fetch.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


extension FSLocalStorage {

    func entities(entityName: String, sortedWithKey1 key1: String!, key2: String?, filteredByPredicate predicate: NSPredicate?) -> [NSManagedObject]! {
        return self.entities(entityName, sortedWithKey1: key1, key2: key2, filteredByPredicate: predicate, fromContext: self.mainObjectContext)
    }
    
    func entities(entityName: String, sortedWithKey sortKey: String!, filteredByPredicate predicate: NSPredicate?) -> [NSManagedObject]! {
        return self.entities(entityName, sortedWithKey1: sortKey, key2: nil, filteredByPredicate: predicate, fromContext: self.mainObjectContext)
    }
    
    func entities(entityName: String, sortedWithKey sortKey: String!, filteredByPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext!) -> [NSManagedObject]! {
        return self.entities(entityName, sortedWithKey1: sortKey, key2: nil, filteredByPredicate: predicate, fromContext: context)
    }
    
    func entities(entityName: String, sortedWithKey1 key1: String!, key2: String?, filteredByPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [NSManagedObject]! {
        let fetchRequest = NSFetchRequest()
        
        let entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        var sortDescriptors = [NSSortDescriptor]()
        sortDescriptors.append(NSSortDescriptor(key: key1, ascending: true))
        if nil != key2 {
            sortDescriptors.append(NSSortDescriptor(key: key2, ascending: true))
        }
        fetchRequest.sortDescriptors = sortDescriptors
        
        fetchRequest.predicate = predicate
        var result: [NSManagedObject]!
        do {
            result = try context.executeFetchRequest(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Error insert: " + error.description)
            result = [NSManagedObject]()
        }
        return result
    }
}
