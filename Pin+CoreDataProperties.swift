//
//  Pin+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Sean Perez on 7/14/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Pin {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var alreadyHasPhotos: NSNumber?
    @NSManaged var photos: NSSet?

}
