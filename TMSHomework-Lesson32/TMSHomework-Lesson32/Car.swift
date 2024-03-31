//
//  Car.swift
//  TMSHomework-Lesson32
//
//  Created by Наталья Мазур on 1.04.24.
//

import Foundation
import RealmSwift

class Car: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var maxSpeed: Int
    @Persisted var weight: Int
    @Persisted var acceleration: Double
    
    convenience init(name: String, maxSpeed: Int, weight: Int, acceleration: Double) {
        self.init()
        self.name = name
        self.maxSpeed = maxSpeed
        self.weight = weight
        self.acceleration = acceleration
    }
}
