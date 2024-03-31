//
//  ViewController.swift
//  TMSHomework-Lesson32
//
//  Created by Наталья Мазур on 31.03.24.
//

import RealmSwift
import UIKit

class ViewController: UITableViewController {
    var cars: [Car] = []

    private lazy var realm: Realm? = {
        do {
            let _realm = try Realm()
            return _realm
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        guard let realm else {
            presentFailureAlert("Can't get saved values")
            return
        }

        cars = realm.objects(Car.self).map { $0 }
    }

    private func presentFailureAlert(_ message: String) {
        let alert = UIAlertController(title: "Failure", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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

            self?.addCar(name: nameToSave, maxSpeed: maxSpeedToSave, weight: weightToSave, acceleration: accelerationToSave)

            self?.tableView.reloadData()
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

    private func addCar(name: String, maxSpeed: Int, weight: Int, acceleration: Double) {
        let carObject = Car(name: name, maxSpeed: maxSpeed, weight: weight, acceleration: acceleration)
        guard let realm else {
            presentFailureAlert("Something went wrong with database")
            return
        }

        do {
            try realm.write {
                realm.add(carObject)
            }
            cars.append(carObject)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - TableViewDelegate & TableViewDataSource methods

extension ViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        super.tableView(tableView, numberOfRowsInSection: section)
        return cars.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.tableView(tableView, cellForRowAt: indexPath)

        let car = cars[indexPath.row]
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
            let carId = cars[indexPath.row]._id

            guard let realm else {
                presentFailureAlert("Something went wrong with database")
                return
            }

            do {
                let deletingCar = realm.object(ofType: Car.self, forPrimaryKey: carId)
                guard let deletingCar else {
                    presentFailureAlert("Can't identify the car")
                    return
                }
                try realm.write {
                    realm.delete(deletingCar)
                    self.cars.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }

            } catch {
                presentFailureAlert(error.localizedDescription)
            }

            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carId = cars[indexPath.row]._id

        guard let realm else {
            presentFailureAlert("Something went wrong with database")
            return
        }

        let message = """
        Max speed: \(realm.object(ofType: Car.self, forPrimaryKey: carId)?.maxSpeed ?? 0) km/h
        Car weight: \(realm.object(ofType: Car.self, forPrimaryKey: carId)?.weight ?? 0) kg
        Acceleration 0-100: \(realm.object(ofType: Car.self, forPrimaryKey: carId)?.acceleration ?? 0.0) seconds
        """

        let alert = UIAlertController(title: realm.object(ofType: Car.self, forPrimaryKey: carId)?.name ?? "",
                                      message: message,
                                      preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
