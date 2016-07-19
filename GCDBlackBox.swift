//
//  GCDBlackBox.swift
//  VirtualTourist
//
//  Created by Sean Perez on 7/18/16.
//  Copyright © 2016 SeanPerez. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}
