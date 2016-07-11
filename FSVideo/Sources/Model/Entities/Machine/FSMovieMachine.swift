//
//  FSMovieMachine.swift
//
//  Created by Alexey Bodnya on 05/06/16.
//  Copyright (c) 2016 Alexey Bodnya. All rights reserved.
//

import Foundation
import CoreData


class FSMovieMachine: NSManagedObject {

    @NSManaged var isFavorite: Bool
    @NSManaged var lastUsedDate: NSDate?
    @NSManaged var link: String?
    @NSManaged var movieDescription: String?
    @NSManaged var movieId: String?
    @NSManaged var poster: String?
    @NSManaged var screen: String?
    @NSManaged var section: String?
    @NSManaged var source: Int32
    @NSManaged var title: String?
    @NSManaged var cast: NSSet
    @NSManaged var countries: NSSet
    @NSManaged var directors: NSSet
    @NSManaged var files: NSSet
    @NSManaged var folders: NSSet
    @NSManaged var genres: NSSet
    @NSManaged var images: NSSet
    @NSManaged var reviews: NSSet
    @NSManaged var years: NSSet
 
    func addCastValue(value: FSHuman) {
        let items = self.mutableSetValueForKey("cast");
        items.addObject(value)
    }

    func removeCastValue(value: FSHuman) {
        let items = self.mutableSetValueForKey("cast");
        items.removeObject(value)
    }


    func addCountriesValue(value: FSCountry) {
        let items = self.mutableSetValueForKey("countries");
        items.addObject(value)
    }

    func removeCountriesValue(value: FSCountry) {
        let items = self.mutableSetValueForKey("countries");
        items.removeObject(value)
    }


    func addDirectorsValue(value: FSHuman) {
        let items = self.mutableSetValueForKey("directors");
        items.addObject(value)
    }

    func removeDirectorsValue(value: FSHuman) {
        let items = self.mutableSetValueForKey("directors");
        items.removeObject(value)
    }


    func addFilesValue(value: FSFile) {
        let items = self.mutableSetValueForKey("files");
        items.addObject(value)
    }

    func removeFilesValue(value: FSFile) {
        let items = self.mutableSetValueForKey("files");
        items.removeObject(value)
    }


    func addFoldersValue(value: FSFolder) {
        let items = self.mutableSetValueForKey("folders");
        items.addObject(value)
    }

    func removeFoldersValue(value: FSFolder) {
        let items = self.mutableSetValueForKey("folders");
        items.removeObject(value)
    }


    func addGenresValue(value: FSGenre) {
        let items = self.mutableSetValueForKey("genres");
        items.addObject(value)
    }

    func removeGenresValue(value: FSGenre) {
        let items = self.mutableSetValueForKey("genres");
        items.removeObject(value)
    }


    func addImagesValue(value: FSImage) {
        let items = self.mutableSetValueForKey("images");
        items.addObject(value)
    }

    func removeImagesValue(value: FSImage) {
        let items = self.mutableSetValueForKey("images");
        items.removeObject(value)
    }


    func addReviewsValue(value: FSReview) {
        let items = self.mutableSetValueForKey("reviews");
        items.addObject(value)
    }

    func removeReviewsValue(value: FSReview) {
        let items = self.mutableSetValueForKey("reviews");
        items.removeObject(value)
    }


    func addYearsValue(value: FSYear) {
        let items = self.mutableSetValueForKey("years");
        items.addObject(value)
    }

    func removeYearsValue(value: FSYear) {
        let items = self.mutableSetValueForKey("years");
        items.removeObject(value)
    }


}
