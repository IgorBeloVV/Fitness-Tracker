//
//  UserModel.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 06.10.2023.
//

import Foundation
import RealmSwift

class UserModel: Object {
    @Persisted var userFirstName: String = "Unknow"
    @Persisted var userSecondName: String = "Unknow"
    @Persisted var userHeight: Int = 0
    @Persisted var userWeight: Int = 0
    @Persisted var userTarget: Int = 0
    @Persisted var userImage: Data?
}
