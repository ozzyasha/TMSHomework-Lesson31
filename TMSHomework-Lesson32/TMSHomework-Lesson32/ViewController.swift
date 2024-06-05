//
//  ViewController.swift
//  TMSHomework-Lesson32
//
//  Created by Наталья Мазур on 31.03.24.
//

import RealmSwift
import UIKit

protocol AlertDelegate: AnyObject {
    func presentFailureAlert(_ message: String)
}

class ViewController: UITableViewController, AlertDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        RealmManager.shared.readAllCarsFromDatabase()
        RealmManager.shared.delegate = self
    }

    @IBAction func addCar(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Car",
                                      message: "Add a new car",
                                      preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            guard let nameTextField = alert.textFields?[0], let nameToSave = nameTextField.text else {
                self?.presentFailureAlert("Car was not added")
                return
            }

            guard let maxSpeedTextField = alert.textFields?[1], let maxSpeedToSave = Int(maxSpeedTextField.text ?? "No data") else {
                self?.presentFailureAlert("Car was not added")
                return
            }

            guard let weightTextField = alert.textFields?[2], let weightToSave = Int(weightTextField.text ?? "No data") else {
                self?.presentFailureAlert("Car was not added")
                return
            }

            guard let accelerationTextField = alert.textFields?[3], let accelerationToSave = Double(accelerationTextField.text ?? "No data") else {
                self?.presentFailureAlert("Car was not added")
                return
            }

            RealmManager.shared.saveCar(name: nameToSave, maxSpeed: maxSpeedToSave, weight: weightToSave, acceleration: accelerationToSave) {
                self?.tableView.reloadData()
            }
        }

        saveAction.isEnabled = false

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addTextField { textField in
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { _ in
                saveAction.isEnabled = textField.text?.count ?? 0 > 0
            })
        }
        alert.addTextFieldForInt64()
        alert.addTextFieldForInt64()
        alert.addTextFieldForDouble()

        alert.textFields?[0].placeholder = "Car name"
        alert.textFields?[1].placeholder = "Max speed"
        alert.textFields?[2].placeholder = "Car weight"
        alert.textFields?[3].placeholder = "0-100"

        alert.addAction(saveAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
    
    func presentFailureAlert(_ message: String) {
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

// MARK: - TableViewDelegate & TableViewDataSource methods

extension ViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return RealmManager.shared.cars.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)

        let car = RealmManager.shared.cars[indexPath.row]
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
        if editingStyle == .delete {
            let carId = RealmManager.shared.cars[indexPath.row]._id
            
            RealmManager.shared.deleteCar(id: carId, indexPath: indexPath) {
                tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carId = RealmManager.shared.cars[indexPath.row]._id

        let message = """
        Max speed: \(RealmManager.shared.readCar(id: carId).maxSpeed) km/h
        Car weight: \(RealmManager.shared.readCar(id: carId).weight) kg
        Acceleration 0-100: \(RealmManager.shared.readCar(id: carId).acceleration) seconds
        """

        let alert = UIAlertController(title: RealmManager.shared.readCar(id: carId).name,
                                      message: message,
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
