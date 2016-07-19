//
//  Pin.swift
//  VirtualTourist
//
//  Created by Sean Perez on 7/14/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation
import CoreData


class Pin: NSManagedObject {

    convenience init(dictionary: [String:AnyObject], context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entityForName("Pin", inManagedObjectContext: context) {
            self.init(entity: entity, insertIntoManagedObjectContext: context)
            self.latitude = dictionary["latitude"] as! Double
            self.longitude = dictionary["longitude"] as! Double
            self.alreadyHasPhotos = false
        } else {
            fatalError("Unable to find Entity naem!")
        }
    }

}
