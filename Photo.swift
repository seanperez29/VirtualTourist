//
//  Photo.swift
//  VirtualTourist
//
//  Created by Sean Perez on 7/14/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import CoreData


class Photo: NSManagedObject {

    convenience init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            self.path = dictionary["path"] as? String
            self.imageUrl = dictionary["imageUrl"] as? String
        } else {
            fatalError("Unable to find Entity name!")
        }
    }

}
