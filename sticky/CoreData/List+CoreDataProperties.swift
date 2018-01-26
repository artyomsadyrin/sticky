//
//  List+CoreDataProperties.swift
//  sticky
//
//  Created by Artsiom Sadyryn on 1/26/18.
//  Copyright © 2018 Artsiom Sadyryn. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var name: String?
    @NSManaged public var textColor: String?
    @NSManaged public var task: NSSet?

}

// MARK: Generated accessors for task
extension List {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)

}
