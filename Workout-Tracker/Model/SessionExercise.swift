//
//  SessionExercise.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-22.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift

class SessionExercise : Object {
    @objc dynamic var name: String = ""

    
    var parentUserSession = LinkingObjects(fromType: UserWorkoutSession.self, property: "sessionExercises")
}
