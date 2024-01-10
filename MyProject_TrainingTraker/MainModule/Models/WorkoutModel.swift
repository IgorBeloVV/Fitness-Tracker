//
//  WorkoutModel.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 19.09.2023.
//

import Foundation
import RealmSwift

class WorkoutModel: Object {
    @Persisted var workoutDate: Date
    @Persisted var workoutRepeat: Bool = true
    @Persisted var workoutNumberOfDay: Int = 0
    @Persisted var workoutName: String = ""
    @Persisted var workoutSets: Int = 0
    @Persisted var workoutReps: Int = 0
    @Persisted var workoutTimer: Int = 0
    @Persisted var workoutImageName: String?
    @Persisted var workoutStatus: Bool = false
}
