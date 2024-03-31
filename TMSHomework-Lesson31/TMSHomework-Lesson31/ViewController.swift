//
//  ViewController.swift
//  TMSHomework-Lesson31
//
//  Created by Наталья Мазур on 29.03.24.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func addCar(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Car",
                                      message: "Add a new car",
                                      preferredStyle: .alert)
        
        alert.addTextField()
        alert.addTextFieldForInt64()
        alert.addTextFieldForInt64()
        alert.addTextFieldForDouble()
        
        alert.textFields?[0].placeholder = "Car name"
        alert.textFields?[1].placeholder = "Max speed"
        alert.textFields?[2].placeholder = "Car weight"
        alert.textFields?[3].placeholder = "0-100"
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            
            guard let nameTextField = alert.textFields?[0], let nameToSave = nameTextField.text else {
                return
            }
            
            guard let maxSpeedTextField = alert.textFields?[1], let maxSpeedToSave = Int64(maxSpeedTextField.text!) else {
                return
            }
            
            guard let weightTextField = alert.textFields?[2], let weightToSave = Int64(weightTextField.text!) else {
                return
            }
            
            guard let accelerationTextField = alert.textFields?[3], let accelerationToSave = Double(accelerationTextField.text!) else {
                return
            }
            
            CoreDataManager.shared.save(name: nameToSave, maxSpeed: maxSpeedToSave, weight: weightToSave, acceleration: accelerationToSave) {
                self?.tableView.reloadData()
            }
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return CoreDataManager.shared.cars.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)
        
        let car = CoreDataManager.shared.cars[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = car.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            CoreDataManager.shared.cars.remove(at: indexPath.row)
            CoreDataManager.shared.delete(at: indexPath.row) {
                let alert = UIAlertController(title: CoreDataManager.shared.readName(at: indexPath.row),
                                              message: "Can't delete a car.",
                                              preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                
                self.present(alert, animated: true)
            }
            
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = """
        Max speed: \(CoreDataManager.shared.readMaxSpeed(at: indexPath.row)) km/h\n
        Car weight: \(CoreDataManager.shared.readWeight(at: indexPath.row)) kg\n
        Acceleration 0-100: \(CoreDataManager.shared.readAcceleration(at: indexPath.row)) seconds
        """
        
        let alert = UIAlertController(title: CoreDataManager.shared.readName(at: indexPath.row),
                                      message: message,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}


