//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Евгений Стафеев on 01.11.2022.
//

import UIKit
import FirebaseAuth
import RealmSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var feedTabNavigationController : UINavigationController!
    var loginTabNavigationController : UINavigationController!
    var favoriteTabNavigationController : UINavigationController!
    var mapTabNavigationController : UINavigationController!
    var appConfiguration: AppConfiguration?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let tabBarController = UITabBarController()
        
        feedTabNavigationController = UINavigationController.init(rootViewController: FeedViewController())

        let loginVC = LoginViewController()

        loginVC.loginDelegate = MyLoginFactory().makeLoginInspector()
        loginTabNavigationController = UINavigationController.init(rootViewController: loginVC)

        favoriteTabNavigationController = UINavigationController.init(rootViewController: FavoriteViewController())
        mapTabNavigationController = UINavigationController.init(rootViewController: MapViewController())

        tabBarController.viewControllers = [feedTabNavigationController, loginTabNavigationController, favoriteTabNavigationController, mapTabNavigationController]

        let item1 = UITabBarItem(title: String(localized: "tabBar1Title"), image: UIImage(systemName: "text.bubble"), tag: 0)
        let item3 = UITabBarItem(title: String(localized: "tabBar3Title"), image: UIImage(systemName: "person.fill"), tag: 2)
        let item4 = UITabBarItem(title: String(localized: "tabBar4Title"), image: UIImage(systemName: "star.bubble"), tag: 3)
        let item5 = UITabBarItem(title: String(localized: "tabBar5Title"), image: UIImage(systemName: "map"), tag: 4)
        
        feedTabNavigationController.tabBarItem = item1
        loginTabNavigationController.tabBarItem = item3
        favoriteTabNavigationController.tabBarItem = item4
        mapTabNavigationController.tabBarItem = item5
        
        UITabBar.appearance().tintColor = colorTabBarTint
        UITabBar.appearance().backgroundColor = colorTabBarMainBackground
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window

        appConfiguration = AppConfiguration.first

        if let config = appConfiguration {
            NetworkManager.request(for: config)
        } else {
            print("❗️Bad url to request")
        }

        appConfiguration = AppConfiguration.second

        if let config = appConfiguration {
            NetworkManager.request(for: config)
        } else {
            print("❗️Bad url to request")
        }

        let config = Realm.Configuration(
            schemaVersion: 4)
        Realm.Configuration.defaultConfiguration = config

        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).

         try? Auth.auth().signOut()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        CoreDataModel().saveContext()
    }
    
    
}

