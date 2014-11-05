//
//  Reminder.swift
//  MapKitApp
//
//  Created by Kori Kolodziejczak on 11/5/14.
//  Copyright (c) 2014 Kori Kolodziejczak. All rights reserved.
//

import Foundation
import CoreData

class Reminder: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var date: NSDate
    @NSManaged var radius: String
    @NSManaged var coordinate: String

}
