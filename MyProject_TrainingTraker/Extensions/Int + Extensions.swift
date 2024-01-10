//
//  Int + Extension.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 19.09.2023.
//

import Foundation

extension Int {
    func getTimeFromSeconds() -> String {
        if self % 60 == 0 {
            return "\(self / 60) min"
        } else if self / 60 == 0 {
            return "\(self % 60) sec"
        }
       return "\(self / 60) min \(self % 60) sec"
    }
    
    func convertSeconds() -> (Int, Int) {
        let min = self / 60
        let sec = self % 60
        return (min, sec)
    }
    
    func setZeroForSeconds() -> String {
        Double(self) / 10 < 1 ? "0\(self)" : "\(self)"
    }
}
