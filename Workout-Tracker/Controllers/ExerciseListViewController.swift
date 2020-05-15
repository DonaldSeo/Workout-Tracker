//
//  ExerciseListViewController.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-21.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import SCLAlertView

class ExerciseListViewController: SwipeTableViewController {
    
    var exercises: Results<Exercise>?
    let realm = try! Realm()

    var selectedSession: UserWorkoutSession?

    var selectedWorkout: Workout? {
        didSet {
            loadExercises()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("exerciselist view did load")
        print(selectedSession as Any)

    }
    
    
    // MARK: - tableview DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        cell.textLabel?.text = exercises?[indexPath.row].title ?? "No exercise Items Added"
            
        return cell
    }
    
    
    // MARK: - tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO - when selecting each tableview cell (exercise) add them to other Data Model and display it in different view(possibly new view controller for User's selected workout plan) - ALMOST DONE

        // TODO2 - show alert popup to indicate that exercise has been added
        // TODO3 - when selectedSEssion == nil, do other thing when user selects the tableviewcell row

        if let exercise = exercises?[indexPath.row] {
            
            //checking if user has entered exercice view from workout session tab
            if (selectedSession != nil) {
                do {
                    try realm.write {
                        //item.done = !item.done
                        //realm.delete(item)
                        let newSessionExercise = SessionExercise()
                        newSessionExercise.name = exercise.title
                        selectedSession?.sessionExercises.append(newSessionExercise)
                        NotificationCenter.default.post(name: Notification.Name("SessionExerciseAdded"), object: nil)
                        SCLAlertView().showNotice("Exercise Added to", subTitle: selectedSession!.sessionTitle)
                        
                    }
                } catch {
                    SCLAlertView().showError("Failure", subTitle: "something went wrong when adding exercise")
                    print("Error saving done status, \(error)")
                }
            }
        }
//        Notification.default.post(name: .sessionExerciseAdded, object: nil)
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true)

    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        //CREATE
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Exercise", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Exercise", style: .default) { (action) in
            //what will happen once the user clicks the Add Item Button on our UIAlert
            
            if let currentWorkout = self.selectedWorkout {
                do {
                    try self.realm.write {
                        let newExercise = Exercise()
                        newExercise.title = textField.text!
                        //newExercise.dateCreated = Date()
                        currentWorkout.exercises.append(newExercise)
                    }
                } catch {
                    print("Error saving new exercises, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Exercise"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    func loadExercises() {

        exercises = selectedWorkout?.exercises.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
    // MARK: - Delete date from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let exerciseForDeletion = self.exercises?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(exerciseForDeletion)
                }
            } catch {
                print("error deleting category, \(error)")
            }
        }
    }
}

// MARK: - Search Bar Methods
extension ExerciseListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
        exercises = exercises?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }




    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadExercises()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }

}

