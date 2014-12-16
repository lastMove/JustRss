//
//  Feeds.swift
//  JustRss
//
//  Created by jason akakpo on 16/12/2014.
//  Copyright (c) 2014 More Than That. All rights reserved.
//

import Foundation
import CoreData

class Feeds: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var link: String
    @NSManaged var orderId: NSNumber

}
