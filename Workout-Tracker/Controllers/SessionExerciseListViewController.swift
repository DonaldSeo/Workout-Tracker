//
//  SessionExerciseListViewController.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-22.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class SessionExerciseListViewController: UITableViewController {
    
    var sessionExercises: Results<SessionExercise>?
    

    let realm = try! Realm()
    
    var selectedSession: UserWorkoutSession? {
        didSet {
            loadSessionExercises()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding observer in notification center
        NotificationCenter.default.addObserver(self, selector: #selector(loadSessionExercises), name: .sessionExerciseAdded, object: nil)
        
    }
    
    
    
    @IBAction func AddExerciseToSessionButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowAvailableWorkoutList", sender: self)
    }

    
    // MARK: - tableview DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sessionExercises?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionExerciseCell", for: indexPath)
        
        if let sessionExercise = sessionExercises?[indexPath.row] {
            cell.textLabel?.text = sessionExercise.name
            
            //ternery operator
            // value = condition ? valueIfTrue : valueIfFalse
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
    }
    
    // MARK: - tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO - when selecting each tableview cell (exercise) add them to other Data Model and display it in different view(possibly new view controller for User's selected workout plan)
        if let exercise = sessionExercises?[indexPath.row] {
            performSegue(withIdentifier: "GoToLogExercise", sender: self)
        }
        
//        if let exercise = exercises?[indexPath.row] {
//            do {
//                try realm.write {
//                    //item.done = !item.done
//                    //realm.delete(item)
//                }
//            } catch {
//                print("Error saving done status, \(error)")
//            }
//        }
//        tableView.reloadData()
//
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let destinationVC = segue.destination as! ExerciseSetViewController
//
//        if let indexPath = tableView.indexPathForSelectedRow {
//            destinationVC.selectedExercise = exercises?[indexPath.row]
//        }
        
        if (segue.identifier == "ShowAvailableWorkoutList") {
            let destinationVC = segue.destination as! WorkoutListViewController
            destinationVC.selectedSession = selectedSession
            
        }
        if (segue.identifier == "GoToLogExercise") {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! LogExerciseViewController
                destinationVC.currentExercise = sessionExercises?[indexPath.row]
            }
            
        }
    }
    
    
    @objc func loadSessionExercises() {
        
        sessionExercises = selectedSession?.sessionExercises.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }


    

    
}

extension Notification.Name {
    static let sessionExerciseAdded = Notification.Name("SessionExerciseAdded")
    
}
