//
//  Car+CoreDataProperties.swift
//  TMSHomework-Lesson31
//
//  Created by Наталья Мазур on 31.03.24.
//
//

import Foundation
import CoreData


extension Car {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Car> {
        return NSFetchRequest<Car>(entityName: "Car")
    }

    @NSManaged public var name: String?
    @NSManaged public var maxSpeed: Int64
    @NSManaged public var weight: Int64
    @NSManaged public var acceleration: Double

}

extension Car : Identifiable {

}
