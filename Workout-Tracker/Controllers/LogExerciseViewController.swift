//
//  LogExerciseViewController.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-24.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit



class LogExerciseViewController: UITableViewController{
    
    var currentExercise: SessionExercise?
//    var finishedExerciceSets: List<FinishedExerciseSets>? {
//        didSet{
//            tableView.reloadData()
//        }
//    }
    var finishedExerciseSets: [(weight: String, reps: String)]? = [] {
        didSet {
            tableView.reloadData()
        }
    }

    
    lazy var realm = try! Realm()
    
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weightTextField.delegate = self
        repsTextField.delegate = self
        weightTextField.text = "0"
        repsTextField.text = "0"
    }
     
// MARK: - Button press methods
    @IBAction func RecordButtonPressed(_ sender: UIButton) {
        
        
        if let weightText = weightTextField?.text, let repsText = repsTextField?.text {
            do {
                try realm.write {
                    let newFinishedSession = FinishedExerciseSets()
                    newFinishedSession.exerciseName = currentExercise!.name
                    newFinishedSession.weight = Double(weightText)!
                    newFinishedSession.reps = Int(repsText)!
                    newFinishedSession.dateCreated = Date()
                    finishedExerciseSets?.append((weight: weightText, reps: repsText))
                    realm.add(newFinishedSession)
                }
            } catch {
                print("Error saving finished Exercise, \(error)")
            }
        }
    }
    
    @IBAction func DoneButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    // MARK: - tableview DataSource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FinishedExerciseSetCell", for: indexPath)
        
        if let finishedExercise = finishedExerciseSets?[indexPath.row] {
            cell.textLabel?.text = "weight: \(finishedExercise.weight) x reps: \(finishedExercise.reps)"
        } else {
            cell.textLabel?.text = "Record your exercise log"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return finishedExerciseSets?.count ?? 1
    }
    

}

// MARK: - UITextfield delegate methods
extension LogExerciseViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldString = textField.text, let range = Range(range, in: textFieldString) else {
            return false
        }
        let newString = textFieldString.replacingCharacters(in: range, with: string)
        if newString.isEmpty {
            textField.text = "0"
            return false
        } else if textField.text == "0" {
            textField.text = string
            return false
        }
        return true
    }

}
