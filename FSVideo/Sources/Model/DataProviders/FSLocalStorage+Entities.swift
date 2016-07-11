//
//  FSLocalStorage+Entities.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


extension FSLocalStorage {

    // MARK: Country

    /*!
    *  Use this method if you want to fetch specified country in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSCountry> object or nil, if it doesn't exist
    */
    func country(withID identifier: AnyObject!) -> FSCountry? {
        return self.country(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all countries in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSCountry objects or empty array, if there aren't any objects
    */
    func allCountries() -> [FSCountry]! {
        return self.countries(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all countries that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSCountry objects or empty array, if there aren't any objects, passing predicate
    */
    func countries(withPredicate predicate: NSPredicate?) -> [FSCountry]! {
        return self.countries(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified country in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSCountry object or nil, if it doesn't exist
    */
    func country(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSCountry? {
        return self.countries(withPredicate: NSPredicate(format: "(%K == %@)", FSCountry.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all countries in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSCountry objects or empty array, if there aren't any objects
    */
    func allCountries(fromContext context: NSManagedObjectContext) -> [FSCountry]! {
        return self.countries(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all countries that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSCountry objects or empty array, if there aren't any objects, passing predicate
    */
    func countries(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSCountry]! {
        return self.entities("Country", sortedWithKey: FSCountry.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSCountry]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSCountry object
    */
    func insertCountry() -> FSCountry! {
        return self.insertCountry(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert country in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSCountry object
    */
    func insertCountry(inContext context: NSManagedObjectContext!) -> FSCountry! {
        return NSEntityDescription.insertNewObjectForEntityForName("Country", inManagedObjectContext: context) as! FSCountry
    }

    /*!
    *  Use this method if you want to insert country in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSCountry object or existed
    */
    func insertCountry(withUniqueValue uniqueValue: AnyObject!) -> FSCountry! {
        return self.insertCountry(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert country in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSCountry object or existed
    */
    func insertCountry(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSCountry! {
        var result = self.country(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertCountry(inContext:context)
            result!.setValue(uniqueValue, forKey: FSCountry.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary country, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSCountry object in In Memory Storage
    */
    func createTempCountry() -> FSCountry! {
        return self.insertCountry(inContext: self.inMemoryObjectContext)
    }

    // MARK: File

    /*!
    *  Use this method if you want to fetch specified file in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSFile> object or nil, if it doesn't exist
    */
    func file(withID identifier: AnyObject!) -> FSFile? {
        return self.file(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all files in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSFile objects or empty array, if there aren't any objects
    */
    func allFiles() -> [FSFile]! {
        return self.files(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all files that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSFile objects or empty array, if there aren't any objects, passing predicate
    */
    func files(withPredicate predicate: NSPredicate?) -> [FSFile]! {
        return self.files(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified file in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSFile object or nil, if it doesn't exist
    */
    func file(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSFile? {
        return self.files(withPredicate: NSPredicate(format: "(%K == %@)", FSFile.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all files in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSFile objects or empty array, if there aren't any objects
    */
    func allFiles(fromContext context: NSManagedObjectContext) -> [FSFile]! {
        return self.files(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all files that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSFile objects or empty array, if there aren't any objects, passing predicate
    */
    func files(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSFile]! {
        return self.entities("File", sortedWithKey: FSFile.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSFile]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSFile object
    */
    func insertFile() -> FSFile! {
        return self.insertFile(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert file in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSFile object
    */
    func insertFile(inContext context: NSManagedObjectContext!) -> FSFile! {
        return NSEntityDescription.insertNewObjectForEntityForName("File", inManagedObjectContext: context) as! FSFile
    }

    /*!
    *  Use this method if you want to insert file in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSFile object or existed
    */
    func insertFile(withUniqueValue uniqueValue: AnyObject!) -> FSFile! {
        return self.insertFile(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert file in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSFile object or existed
    */
    func insertFile(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSFile! {
        var result = self.file(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertFile(inContext:context)
            result!.setValue(uniqueValue, forKey: FSFile.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary file, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSFile object in In Memory Storage
    */
    func createTempFile() -> FSFile! {
        return self.insertFile(inContext: self.inMemoryObjectContext)
    }

    // MARK: Folder

    /*!
    *  Use this method if you want to fetch specified folder in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSFolder> object or nil, if it doesn't exist
    */
    func folder(withID identifier: AnyObject!) -> FSFolder? {
        return self.folder(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all folders in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSFolder objects or empty array, if there aren't any objects
    */
    func allFolders() -> [FSFolder]! {
        return self.folders(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all folders that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSFolder objects or empty array, if there aren't any objects, passing predicate
    */
    func folders(withPredicate predicate: NSPredicate?) -> [FSFolder]! {
        return self.folders(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified folder in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSFolder object or nil, if it doesn't exist
    */
    func folder(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSFolder? {
        return self.folders(withPredicate: NSPredicate(format: "(%K == %@)", FSFolder.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all folders in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSFolder objects or empty array, if there aren't any objects
    */
    func allFolders(fromContext context: NSManagedObjectContext) -> [FSFolder]! {
        return self.folders(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all folders that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSFolder objects or empty array, if there aren't any objects, passing predicate
    */
    func folders(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSFolder]! {
        return self.entities("Folder", sortedWithKey: FSFolder.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSFolder]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSFolder object
    */
    func insertFolder() -> FSFolder! {
        return self.insertFolder(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert folder in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSFolder object
    */
    func insertFolder(inContext context: NSManagedObjectContext!) -> FSFolder! {
        return NSEntityDescription.insertNewObjectForEntityForName("Folder", inManagedObjectContext: context) as! FSFolder
    }

    /*!
    *  Use this method if you want to insert folder in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSFolder object or existed
    */
    func insertFolder(withUniqueValue uniqueValue: AnyObject!) -> FSFolder! {
        return self.insertFolder(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert folder in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSFolder object or existed
    */
    func insertFolder(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSFolder! {
        var result = self.folder(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertFolder(inContext:context)
            result!.setValue(uniqueValue, forKey: FSFolder.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary folder, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSFolder object in In Memory Storage
    */
    func createTempFolder() -> FSFolder! {
        return self.insertFolder(inContext: self.inMemoryObjectContext)
    }

    // MARK: Genre

    /*!
    *  Use this method if you want to fetch specified genre in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSGenre> object or nil, if it doesn't exist
    */
    func genre(withID identifier: AnyObject!) -> FSGenre? {
        return self.genre(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all genres in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSGenre objects or empty array, if there aren't any objects
    */
    func allGenres() -> [FSGenre]! {
        return self.genres(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all genres that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSGenre objects or empty array, if there aren't any objects, passing predicate
    */
    func genres(withPredicate predicate: NSPredicate?) -> [FSGenre]! {
        return self.genres(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified genre in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSGenre object or nil, if it doesn't exist
    */
    func genre(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSGenre? {
        return self.genres(withPredicate: NSPredicate(format: "(%K == %@)", FSGenre.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all genres in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSGenre objects or empty array, if there aren't any objects
    */
    func allGenres(fromContext context: NSManagedObjectContext) -> [FSGenre]! {
        return self.genres(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all genres that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSGenre objects or empty array, if there aren't any objects, passing predicate
    */
    func genres(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSGenre]! {
        return self.entities("Genre", sortedWithKey: FSGenre.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSGenre]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSGenre object
    */
    func insertGenre() -> FSGenre! {
        return self.insertGenre(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert genre in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSGenre object
    */
    func insertGenre(inContext context: NSManagedObjectContext!) -> FSGenre! {
        return NSEntityDescription.insertNewObjectForEntityForName("Genre", inManagedObjectContext: context) as! FSGenre
    }

    /*!
    *  Use this method if you want to insert genre in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSGenre object or existed
    */
    func insertGenre(withUniqueValue uniqueValue: AnyObject!) -> FSGenre! {
        return self.insertGenre(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert genre in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSGenre object or existed
    */
    func insertGenre(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSGenre! {
        var result = self.genre(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertGenre(inContext:context)
            result!.setValue(uniqueValue, forKey: FSGenre.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary genre, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSGenre object in In Memory Storage
    */
    func createTempGenre() -> FSGenre! {
        return self.insertGenre(inContext: self.inMemoryObjectContext)
    }

    // MARK: Human

    /*!
    *  Use this method if you want to fetch specified human in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSHuman> object or nil, if it doesn't exist
    */
    func human(withID identifier: AnyObject!) -> FSHuman? {
        return self.human(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all humans in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSHuman objects or empty array, if there aren't any objects
    */
    func allHumans() -> [FSHuman]! {
        return self.humans(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all humans that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSHuman objects or empty array, if there aren't any objects, passing predicate
    */
    func humans(withPredicate predicate: NSPredicate?) -> [FSHuman]! {
        return self.humans(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified human in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSHuman object or nil, if it doesn't exist
    */
    func human(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSHuman? {
        return self.humans(withPredicate: NSPredicate(format: "(%K == %@)", FSHuman.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all humans in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSHuman objects or empty array, if there aren't any objects
    */
    func allHumans(fromContext context: NSManagedObjectContext) -> [FSHuman]! {
        return self.humans(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all humans that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSHuman objects or empty array, if there aren't any objects, passing predicate
    */
    func humans(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSHuman]! {
        return self.entities("Human", sortedWithKey: FSHuman.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSHuman]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSHuman object
    */
    func insertHuman() -> FSHuman! {
        return self.insertHuman(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert human in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSHuman object
    */
    func insertHuman(inContext context: NSManagedObjectContext!) -> FSHuman! {
        return NSEntityDescription.insertNewObjectForEntityForName("Human", inManagedObjectContext: context) as! FSHuman
    }

    /*!
    *  Use this method if you want to insert human in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSHuman object or existed
    */
    func insertHuman(withUniqueValue uniqueValue: AnyObject!) -> FSHuman! {
        return self.insertHuman(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert human in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSHuman object or existed
    */
    func insertHuman(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSHuman! {
        var result = self.human(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertHuman(inContext:context)
            result!.setValue(uniqueValue, forKey: FSHuman.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary human, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSHuman object in In Memory Storage
    */
    func createTempHuman() -> FSHuman! {
        return self.insertHuman(inContext: self.inMemoryObjectContext)
    }

    // MARK: Image

    /*!
    *  Use this method if you want to fetch specified image in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSImage> object or nil, if it doesn't exist
    */
    func image(withID identifier: AnyObject!) -> FSImage? {
        return self.image(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all images in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSImage objects or empty array, if there aren't any objects
    */
    func allImages() -> [FSImage]! {
        return self.images(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all images that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSImage objects or empty array, if there aren't any objects, passing predicate
    */
    func images(withPredicate predicate: NSPredicate?) -> [FSImage]! {
        return self.images(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified image in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSImage object or nil, if it doesn't exist
    */
    func image(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSImage? {
        return self.images(withPredicate: NSPredicate(format: "(%K == %@)", FSImage.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all images in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSImage objects or empty array, if there aren't any objects
    */
    func allImages(fromContext context: NSManagedObjectContext) -> [FSImage]! {
        return self.images(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all images that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSImage objects or empty array, if there aren't any objects, passing predicate
    */
    func images(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSImage]! {
        return self.entities("Image", sortedWithKey: FSImage.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSImage]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSImage object
    */
    func insertImage() -> FSImage! {
        return self.insertImage(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert image in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSImage object
    */
    func insertImage(inContext context: NSManagedObjectContext!) -> FSImage! {
        return NSEntityDescription.insertNewObjectForEntityForName("Image", inManagedObjectContext: context) as! FSImage
    }

    /*!
    *  Use this method if you want to insert image in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSImage object or existed
    */
    func insertImage(withUniqueValue uniqueValue: AnyObject!) -> FSImage! {
        return self.insertImage(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert image in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSImage object or existed
    */
    func insertImage(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSImage! {
        var result = self.image(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertImage(inContext:context)
            result!.setValue(uniqueValue, forKey: FSImage.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary image, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSImage object in In Memory Storage
    */
    func createTempImage() -> FSImage! {
        return self.insertImage(inContext: self.inMemoryObjectContext)
    }

    // MARK: Movie

    /*!
    *  Use this method if you want to fetch specified movie in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSMovie> object or nil, if it doesn't exist
    */
    func movie(withID identifier: AnyObject!) -> FSMovie? {
        return self.movie(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all movies in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSMovie objects or empty array, if there aren't any objects
    */
    func allMovies() -> [FSMovie]! {
        return self.movies(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all movies that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSMovie objects or empty array, if there aren't any objects, passing predicate
    */
    func movies(withPredicate predicate: NSPredicate?) -> [FSMovie]! {
        return self.movies(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified movie in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSMovie object or nil, if it doesn't exist
    */
    func movie(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSMovie? {
        return self.movies(withPredicate: NSPredicate(format: "(%K == %@)", FSMovie.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all movies in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSMovie objects or empty array, if there aren't any objects
    */
    func allMovies(fromContext context: NSManagedObjectContext) -> [FSMovie]! {
        return self.movies(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all movies that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSMovie objects or empty array, if there aren't any objects, passing predicate
    */
    func movies(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSMovie]! {
        return self.entities("Movie", sortedWithKey: FSMovie.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSMovie]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSMovie object
    */
    func insertMovie() -> FSMovie! {
        return self.insertMovie(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert movie in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSMovie object
    */
    func insertMovie(inContext context: NSManagedObjectContext!) -> FSMovie! {
        return NSEntityDescription.insertNewObjectForEntityForName("Movie", inManagedObjectContext: context) as! FSMovie
    }

    /*!
    *  Use this method if you want to insert movie in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSMovie object or existed
    */
    func insertMovie(withUniqueValue uniqueValue: AnyObject!) -> FSMovie! {
        return self.insertMovie(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert movie in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSMovie object or existed
    */
    func insertMovie(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSMovie! {
        var result = self.movie(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertMovie(inContext:context)
            result!.setValue(uniqueValue, forKey: FSMovie.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary movie, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSMovie object in In Memory Storage
    */
    func createTempMovie() -> FSMovie! {
        return self.insertMovie(inContext: self.inMemoryObjectContext)
    }

    // MARK: Review

    /*!
    *  Use this method if you want to fetch specified review in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSReview> object or nil, if it doesn't exist
    */
    func review(withID identifier: AnyObject!) -> FSReview? {
        return self.review(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all reviews in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSReview objects or empty array, if there aren't any objects
    */
    func allReviews() -> [FSReview]! {
        return self.reviews(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all reviews that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSReview objects or empty array, if there aren't any objects, passing predicate
    */
    func reviews(withPredicate predicate: NSPredicate?) -> [FSReview]! {
        return self.reviews(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified review in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSReview object or nil, if it doesn't exist
    */
    func review(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSReview? {
        return self.reviews(withPredicate: NSPredicate(format: "(%K == %@)", FSReview.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all reviews in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSReview objects or empty array, if there aren't any objects
    */
    func allReviews(fromContext context: NSManagedObjectContext) -> [FSReview]! {
        return self.reviews(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all reviews that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSReview objects or empty array, if there aren't any objects, passing predicate
    */
    func reviews(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSReview]! {
        return self.entities("Review", sortedWithKey: FSReview.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSReview]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSReview object
    */
    func insertReview() -> FSReview! {
        return self.insertReview(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert review in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSReview object
    */
    func insertReview(inContext context: NSManagedObjectContext!) -> FSReview! {
        return NSEntityDescription.insertNewObjectForEntityForName("Review", inManagedObjectContext: context) as! FSReview
    }

    /*!
    *  Use this method if you want to insert review in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSReview object or existed
    */
    func insertReview(withUniqueValue uniqueValue: AnyObject!) -> FSReview! {
        return self.insertReview(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert review in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSReview object or existed
    */
    func insertReview(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSReview! {
        var result = self.review(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertReview(inContext:context)
            result!.setValue(uniqueValue, forKey: FSReview.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary review, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSReview object in In Memory Storage
    */
    func createTempReview() -> FSReview! {
        return self.insertReview(inContext: self.inMemoryObjectContext)
    }

    // MARK: SearchQuery

    /*!
    *  Use this method if you want to fetch specified searchQuery in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSSearchQuery> object or nil, if it doesn't exist
    */
    func searchQuery(withID identifier: AnyObject!) -> FSSearchQuery? {
        return self.searchQuery(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all searchQueries in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSSearchQuery objects or empty array, if there aren't any objects
    */
    func allSearchQueries() -> [FSSearchQuery]! {
        return self.searchQueries(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all searchQueries that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSSearchQuery objects or empty array, if there aren't any objects, passing predicate
    */
    func searchQueries(withPredicate predicate: NSPredicate?) -> [FSSearchQuery]! {
        return self.searchQueries(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified searchQuery in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSSearchQuery object or nil, if it doesn't exist
    */
    func searchQuery(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSSearchQuery? {
        return self.searchQueries(withPredicate: NSPredicate(format: "(%K == %@)", FSSearchQuery.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all searchQueries in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSSearchQuery objects or empty array, if there aren't any objects
    */
    func allSearchQueries(fromContext context: NSManagedObjectContext) -> [FSSearchQuery]! {
        return self.searchQueries(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all searchQueries that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSSearchQuery objects or empty array, if there aren't any objects, passing predicate
    */
    func searchQueries(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSSearchQuery]! {
        return self.entities("SearchQuery", sortedWithKey: FSSearchQuery.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSSearchQuery]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSSearchQuery object
    */
    func insertSearchQuery() -> FSSearchQuery! {
        return self.insertSearchQuery(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert searchQuery in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSSearchQuery object
    */
    func insertSearchQuery(inContext context: NSManagedObjectContext!) -> FSSearchQuery! {
        return NSEntityDescription.insertNewObjectForEntityForName("SearchQuery", inManagedObjectContext: context) as! FSSearchQuery
    }

    /*!
    *  Use this method if you want to insert searchQuery in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSSearchQuery object or existed
    */
    func insertSearchQuery(withUniqueValue uniqueValue: AnyObject!) -> FSSearchQuery! {
        return self.insertSearchQuery(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert searchQuery in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSSearchQuery object or existed
    */
    func insertSearchQuery(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSSearchQuery! {
        var result = self.searchQuery(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertSearchQuery(inContext:context)
            result!.setValue(uniqueValue, forKey: FSSearchQuery.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary searchQuery, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSSearchQuery object in In Memory Storage
    */
    func createTempSearchQuery() -> FSSearchQuery! {
        return self.insertSearchQuery(inContext: self.inMemoryObjectContext)
    }

    // MARK: Year

    /*!
    *  Use this method if you want to fetch specified year in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param identifier unique value
    *  @return id<FSYear> object or nil, if it doesn't exist
    */
    func year(withID identifier: AnyObject!) -> FSYear? {
        return self.year(withID: identifier, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch all years in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param context Context in which object will be created
    *  @return Array of all FSYear objects or empty array, if there aren't any objects
    */
    func allYears() -> [FSYear]! {
        return self.years(withPredicate: nil)
    }

    /*!
    *  Use this method if you want to fetch all years that matches predicate in NSManagedObjectContext, which is specified for using in Main Queue
    *  @param predicate Filtering predicate
    *  @return Array of FSYear objects or empty array, if there aren't any objects, passing predicate
    */
    func years(withPredicate predicate: NSPredicate?) -> [FSYear]! {
        return self.years(withPredicate: predicate, fromContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to fetch specified year in specified NSManagedObjectContext
    *  @param identifier unique value
    *  @param context Context in which object will be created
    *  @return FSYear object or nil, if it doesn't exist
    */
    func year(withID identifier: AnyObject!, fromContext context: NSManagedObjectContext) -> FSYear? {
        return self.years(withPredicate: NSPredicate(format: "(%K == %@)", FSYear.uniqueFieldKeyPath(), String(identifier)), fromContext: context).first
    }

    /*!
    *  Use this method if you want to fetch all years in specified NSManagedObjectContext
    *  @param context Context in which object will be created
    *  @return Array of all FSYear objects or empty array, if there aren't any objects
    */
    func allYears(fromContext context: NSManagedObjectContext) -> [FSYear]! {
        return self.years(withPredicate: nil, fromContext: context)
    }

    /*!
    *  Use this method if you want to fetch all years that matches predicate in specified NSManagedObjectContext
    *  @param predicate Filtering predicate
    *  @param context Context in which object will be created
    *  @return Array of FSYear objects or empty array, if there aren't any objects, passing predicate
    */
    func years(withPredicate predicate: NSPredicate?, fromContext context: NSManagedObjectContext) -> [FSYear]! {
        return self.entities("Year", sortedWithKey: FSYear.uniqueFieldKeyPath(), filteredByPredicate: predicate, fromContext: context) as! [FSYear]
    }

    /*!
    *  Use this method if you want to insert amenity in main context without check existing
    *  @return Inserted FSYear object
    */
    func insertYear() -> FSYear! {
        return self.insertYear(inContext: self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert year in specified NSManagedObjectContext without check existing
    *  @param context Context in which object will be created
    *  @return Inserted FSYear object
    */
    func insertYear(inContext context: NSManagedObjectContext!) -> FSYear! {
        return NSEntityDescription.insertNewObjectForEntityForName("Year", inManagedObjectContext: context) as! FSYear
    }

    /*!
    *  Use this method if you want to insert year in main context with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @return Inserted FSYear object or existed
    */
    func insertYear(withUniqueValue uniqueValue: AnyObject!) -> FSYear! {
        return self.insertYear(withUniqueValue: uniqueValue, inContext:self.mainObjectContext)
    }

    /*!
    *  Use this method if you want to insert year in specified NSManagedObjectContext with checking existing by unique value
    *  @param uniqueValue Unique value which matched to primary key
    *  @param context Context in which object will be created
    *  @return Inserted FSYear object or existed
    */
    func insertYear(withUniqueValue uniqueValue: AnyObject!, inContext context: NSManagedObjectContext!) -> FSYear! {
        var result = self.year(withID:uniqueValue, fromContext:context)
        if nil == result {
            result = self.insertYear(inContext:context)
            result!.setValue(uniqueValue, forKey: FSYear.uniqueFieldKeyPath())
        }
        return result!
    }

    /*!
    *  Use this method if you want to init temporary year, which will be placed in memory. Don't use this method if you want to store object in database
    *  @return Inserted FSYear object in In Memory Storage
    */
    func createTempYear() -> FSYear! {
        return self.insertYear(inContext: self.inMemoryObjectContext)
    }

    
}
