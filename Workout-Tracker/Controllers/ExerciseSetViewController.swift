//
//  ExerciseSetViewController.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-22.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ExerciseSetViewController: UIViewController {
    
    var selectedExercise: Exercise?
    let realm = try! Realm()
    var userWorkoutSession: UserWorkoutSession?
    
    
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sessionLabel: UITextField!
    @IBOutlet weak var weightLabel: UITextField!
    @IBOutlet weak var repsLabel: UITextField!
    @IBOutlet weak var setsLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = selectedExercise?.title
        sessionLabel.delegate = self
    }
}

// MARK: - UITextFieldDelegate

extension ExerciseSetViewController: UITextFieldDelegate{
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
    @IBAction func savePressed(_ sender: Any) {
        sessionLabel.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == sessionLabel {
            print("session label detected")
            if let sessionName = sessionLabel.text {
                do {
                    try realm.write {
                        //TODO : need to update instead of creating new entry all the time
                        let newWorkoutSession = UserWorkoutSession()
                        newWorkoutSession.sessionTitle = sessionName
                        realm.add(newWorkoutSession)
                    }
                } catch {
                    print("Error saving userWorkoutSession title with user entered text from Label \(error)")
                }
            }
        }
        if textField == weightLabel {
            print("weight entry finished editing")

        }
        if textField == repsLabel {
            
        }
        if textField == setsLabel {
            
        }
        
    }
}
