//
//  UserWorkoutSession.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-22.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift


class UserWorkoutSession: Object {
    @objc dynamic var sessionTitle: String = ""
    
    let sessionExercises = List<SessionExercise>()
}
