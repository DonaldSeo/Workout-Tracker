//
//  FinishedExercise.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-24.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift

class FinishedExerciseSets: Object {
    
    @objc dynamic var exerciseName: String = ""
    @objc dynamic var weight: Double = 0.0
    @objc dynamic var reps: Int = 0
    @objc dynamic var dateCreated: Date?
}
