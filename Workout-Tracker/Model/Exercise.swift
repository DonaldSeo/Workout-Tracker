//
//  Exercise.swift
//  Workout-Tracker
//
//  Created by Donald Seo on 2020-04-21.
//  Copyright © 2020 Donald Seo. All rights reserved.
//

import Foundation
import RealmSwift

class Exercise: Object {
    @objc dynamic var title: String = ""

    //reverse relationship (object type = Workout.self with property exercises)
    var parentCategory = LinkingObjects(fromType: Workout.self, property: "exercises")
    
}
