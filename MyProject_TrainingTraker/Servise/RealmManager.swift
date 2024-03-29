//
//  RealmManager.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 19.09.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    let realm = try! Realm()
    
    func getResultWorkoutModel() -> Results<WorkoutModel> {
        realm.objects(WorkoutModel.self)
    }
    
    func saveWorkoutModel(_ model: WorkoutModel) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    func deleteWorkoutModel(_ model: WorkoutModel) {
        try! realm.write {
            realm.delete(model)
        }
    }
    
    func updateWorkoutModel(_ model: WorkoutModel, sets: Int, reps: Int) {
        try! realm.write {
            model.workoutSets = sets
            model.workoutReps = reps
        }
    }
    
    func updateTimerWorkoutModel(_ model: WorkoutModel, sets: Int, timer: Int) {
        try! realm.write {
            model.workoutSets = sets
            model.workoutTimer = timer
        }
    }
    
    func updateStatusWorkoutModel(_ model: WorkoutModel) {
        try! realm.write {
            model.workoutStatus = true
        }
    }
    
   func getWorkoutsName() -> [String] {
        var nameArray = [String]()
        let allWorkouts = RealmManager.shared.getResultWorkoutModel()
        
        for workout in allWorkouts {
            if !nameArray.contains(workout.workoutName) {
                nameArray.append(workout.workoutName)
            }
        }
        return nameArray
    }
    //    func printWay() {
    //        print("Путь к базе данных Realm: \(realm.configuration.fileURL?.absoluteString ?? "Не найден")")
    //    }
    
    // USER
    
    func getResultUserModel() -> Results<UserModel> {
        realm.objects(UserModel.self)
    }
    
    func saveUserModel(_ model: UserModel) {
        try! realm.write {
            realm.add(model)
        }
    }
    
    func updateUserModel (model: UserModel) {
        let users = getResultUserModel()
        
        try! realm.write {
            users[0].userFirstName = model.userFirstName
            users[0].userSecondName = model.userSecondName
            users[0].userHeight = model.userHeight
            users[0].userWeight = model.userWeight
            users[0].userTarget = model.userTarget
            users[0].userImage = model.userImage
        }
    }
}
