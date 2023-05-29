//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Евгений Стафеев on 17.05.2023.
//
//

import Foundation
import UserNotifications


class LocalNotificationsService{

    let center = UNUserNotificationCenter.current()

    func registeForLatestUpdatesIfPossible(){

        AppDelegate().registerUpdatesCategory()

        center.requestAuthorization(options: [.sound, .badge]) { success, error in
            if let error = error {
                print(error)
            } else {
                let content = UNMutableNotificationContent()
                content.title = "Посмотрите последние обновления"
                content.badge = 1
                content.sound = .default
                content.categoryIdentifier = "updates"

                var component = DateComponents()
                component.hour = 19

                let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: true)

                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                self.center.add(request)
            }
        }
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate {

    func registerUpdatesCategory(){
        let center = localNotificationsService.center

        let action = UNNotificationAction(identifier: "Показать", title: "Написать секретное сообщение в консоль", options: .destructive)

        let category = UNNotificationCategory(identifier: "updates", actions: [action], intentIdentifiers: [])

        let categories : Set<UNNotificationCategory> = [category]
        center.setNotificationCategories(categories)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        switch response.actionIdentifier {
        case "Показать":
                print("Секретное сообщение в консоле")
        default:
                print("Что то непонятное нажали")
        }

        completionHandler()
    }
}
