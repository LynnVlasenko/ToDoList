//
//  SceneDelegate.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // initial screen display settings
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let initialVc = TasksViewController()
        let navigationController = UINavigationController(rootViewController: initialVc)
        
        window.rootViewController = navigationController
        
        self.window = window
        
        window.makeKeyAndVisible()
    }
}

