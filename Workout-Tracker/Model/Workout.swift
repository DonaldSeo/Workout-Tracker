//
//  Workout.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-21.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift

class Workout: Object {
    @objc dynamic var name: String = ""
    
    //forward relationship to exercise (workout has many exercises)
    let exercises = List<Exercise>()
}
