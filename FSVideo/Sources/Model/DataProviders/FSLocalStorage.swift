//
//  FSLocalStorage.swift
//
//  Created by Alexey Bodnya on 04/11/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSLocalStorage: NSObject {
    
    static let sharedInstance = FSLocalStorage()

    var mainObjectContext: NSManagedObjectContext!
    var managedObjectModel: NSManagedObjectModel!
    var persistentStoreCoordinator: NSPersistentStoreCoordinator!
    var inMemoryObjectContext: NSManagedObjectContext!
    var inMemoryPersistentStoreCoordinator: NSPersistentStoreCoordinator!
    var asyncQueue: NSOperationQueue!
    var asyncContexts: [NSManagedObjectContext]!

    override init() {
        super.init()
        do {
            try self.setupCoreData()
        } catch let error as NSError {
            print("Fail setup database: " + error.description)
        }
    }
    
    func setupCoreData() throws {
        let fileManager = NSFileManager.defaultManager()
        let modelURL = NSBundle.mainBundle().URLForResource("DataBase", withExtension: "momd")!
        self.managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL)
        let homeURL = NSURL.documents()
        let DBFolder = homeURL.URLByAppendingPathComponent(".CoreData")
        if !fileManager.fileExistsAtPath(DBFolder.path!) {
            try fileManager.createDirectoryAtURL(DBFolder, withIntermediateDirectories: true, attributes: nil)
            DBFolder.excludeFromBackup()
        }

        let storeURL = DBFolder.URLByAppendingPathComponent("DataBase.sqlite")
        storeURL.excludeFromBackup()

        self.persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        try self.persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)

        self.mainObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        self.mainObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        self.mainObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        self.inMemoryPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        self.inMemoryObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        self.inMemoryObjectContext.persistentStoreCoordinator = self.inMemoryPersistentStoreCoordinator
        self.inMemoryObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        self.asyncQueue = NSOperationQueue()
        self.asyncQueue.qualityOfService = NSQualityOfService.Background
        self.asyncQueue.maxConcurrentOperationCount = 1
        self.asyncContexts = [NSManagedObjectContext]()
    }
}
