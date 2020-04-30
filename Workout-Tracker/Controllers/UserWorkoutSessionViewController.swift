//
//  UserWorkoutSessionViewController.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-22.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class UserWorkoutSessionViewController: UITableViewController {
    let realm = try! Realm()
    
    var userSessionArray: Results<UserWorkoutSession>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserSession()
    }
    
    @IBAction func AddWorkoutSessionButtonPressed(_ sender: Any) {
            
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Workout Session", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Session", style: .default) { (action) in
            
            
            let newSession = UserWorkoutSession()
            newSession.sessionTitle = textField.text!
            
            self.save(session: newSession)
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Workout Session"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Tableview datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userSessionArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSessionCell", for: indexPath)
        
        cell.textLabel?.text = userSessionArray?[indexPath.row].sessionTitle ?? "No workout sessions added"
        
        return cell
    }
    // MARK: - tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "GoToSessionExercises", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SessionExerciseListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedSession = userSessionArray?[indexPath.row]
        }
    }
    
    // MARK: - Data manipulation methods
    func save(session: UserWorkoutSession) {
        do {
            try realm.write {
                realm.add(session)
            }
        } catch {
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }
    
    func loadUserSession() {

        userSessionArray = realm.objects(UserWorkoutSession.self)

        tableView.reloadData()

    }
    
    
        
}

