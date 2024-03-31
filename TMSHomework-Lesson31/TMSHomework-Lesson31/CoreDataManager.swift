//
//  CoreDataManager.swift
//  TMSHomework-Lesson31
//
//  Created by Наталья Мазур on 31.03.24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    private init() { }
    
    private let queue = DispatchQueue(label: "CoreData")
    static let shared = CoreDataManager()
    
    lazy var cars: [Car] = {
        let managedContext = self.persistentContainer.viewContext
        
        guard let results = try? managedContext.fetch(NSFetchRequest(entityName: "Car")) as? [Car] else { return [] }
        
        return results
    }()
    
    func save(name: String, maxSpeed: Int64, weight: Int64, acceleration: Double, completion: @escaping () -> ()) {
        
        let managedContext = self.persistentContainer.viewContext
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Car",
                                                                 in: managedContext) else { return } // в идеале тут должен быть алерт вместо return
        let car = Car(entity: entityDescription, insertInto: managedContext)
        
        car.name = name
        car.maxSpeed = maxSpeed
        car.weight = weight
        car.acceleration = acceleration
        
        self.saveContext()
        self.cars.append(car)
        
        completion()
    }
    
    func readName(at index: Int) -> String {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.name ?? "No name"
        } catch {
            return(error.localizedDescription)
        }
    }
    
    func readMaxSpeed(at index: Int) -> Int64 {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.maxSpeed
        } catch {
            return -1
        }
    }
    
    func readWeight(at index: Int) -> Int64 {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.weight
        } catch {
            return -1
        }
    }
    
    func readAcceleration(at index: Int) -> Double {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            return resultObject.acceleration
        } catch {
            return -1
        }
    }
    
    func delete(at index: Int, completion: @escaping () -> ()) {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Car")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            let resultObject = results[index] as! Car
            managedContext.delete(resultObject)
            
        } catch {
            completion()
        }
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TMSHomework_Lesson31")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        queue.async {
            let context = self.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }

}
