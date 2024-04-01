//
//  RealmManager.swift
//  TMSHomework-Lesson32
//
//  Created by Наталья Мазур on 1.04.24.
//

import Foundation
import RealmSwift

class RealmManager {
    static let shared = RealmManager()

    weak var delegate: AlertDelegate?
    
    private init() {
    }
    
    var cars: [Car] = []
    
    lazy var realm: Realm? = {
        do {
            let _realm = try Realm()
            return _realm
        } catch {
            delegate?.presentFailureAlert(error.localizedDescription)
            return nil
        }
    }()
    
    func saveCar(name: String, maxSpeed: Int, weight: Int, acceleration: Double, completion: () -> ()) {
        let carObject = Car(name: name, maxSpeed: maxSpeed, weight: weight, acceleration: acceleration)
        guard let realm else {
            delegate?.presentFailureAlert("Something went wrong with database")
            return
        }

        do {
            try realm.write {
                realm.add(carObject)
            }
            cars.append(carObject)
        } catch {
            delegate?.presentFailureAlert(error.localizedDescription)
        }
        
        completion()
    }
    
    func deleteCar(id: ObjectId, indexPath: IndexPath, completion: () -> ()) {
        guard let realm else {
            delegate?.presentFailureAlert("Can't identify the car")
            return
        }
        
        do {
            let deletingCar = realm.object(ofType: Car.self, forPrimaryKey: id)
            guard let deletingCar else {
                
                return
            }
            try realm.write {
                realm.delete(deletingCar)
                cars.remove(at: indexPath.row)
            }

        } catch {
            delegate?.presentFailureAlert(error.localizedDescription)
        }
        
        completion()
    }
    
    func readAllCarsFromDatabase() {
        guard let realm else {
            delegate?.presentFailureAlert("Can't get saved values")
            return
        }
        cars = realm.objects(Car.self).map { $0 }
    }
}
