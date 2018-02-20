//
//  Task+CoreDataProperties.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/30/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var descriptionTask: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var time: NSDate?
    @NSManaged public var list: List?

}
