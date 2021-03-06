//
//  Photo+CoreDataProperties.swift
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

extension Photo {

    @NSManaged var path: String?
    @NSManaged var imageUrl: String?
    @NSManaged var pin: Pin?

}
