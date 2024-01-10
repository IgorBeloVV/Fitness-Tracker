//
//  Notifications.swift
//  MyProject_TrainingTraker
//
//  Created by Belov Igor on 10.10.2023.
//

import UIKit

class Notifications: NSObject {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    func requestAutorization() {
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            self.getNotificationSetting()
        }
    }
    
    func getNotificationSetting() {
        notificationCenter.getNotificationSettings { setting in
        }
    }
    
    func scheduleDateNotification(date: Date, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "Workout"
        content.body = "Today you have training"
        content.badge = 1
        
        var calendar = Calendar.current
        guard let time = TimeZone(abbreviation: "UTC") else { return }
        calendar.timeZone = time
        
        var triggerDate = calendar.dateComponents([.year, .month, .day], from: date)
        triggerDate.hour = 13
        triggerDate.minute = 02
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCenter.add(request) { error in
            if error != nil {
                print (error?.localizedDescription as Any)
            }
        }
    }
}

//MARK: - UNUserNotificationCenterDelegate

extension Notifications: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // вызывается при нажатии на уведомление
        UIApplication.shared.applicationIconBadgeNumber = 0
        notificationCenter.removeAllDeliveredNotifications() //удаляет доставленные уведомления
    }
}
