//
//  ViewController.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-06.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import UIKit
import RealmSwift


class WorkoutViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var workoutArray: Results<Workout>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadWorkout()
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //CREATE
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Workout Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Workout", style: .default) { (action) in
            
            
            let newWorkout = Workout()
            newWorkout.name = textField.text!
            
            self.save(workout: newWorkout)
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Workout Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - tableview datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return workoutArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No workout categories added"
        
        return cell
    }
    
    // MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToExercises", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ExerciseListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    

    // MARK: - Data manipulation methods
    func save(workout: Workout) {
        do {
            try realm.write {
                realm.add(workout)
            }
        } catch {
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadWorkout() {

        workoutArray = realm.objects(Workout.self)

        tableView.reloadData()

    }
}

