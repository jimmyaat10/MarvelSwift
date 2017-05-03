//
//  AppDelegate.swift
//  Marvel
//
//  Created by Albert Arroyo on 23/8/16.
//  Copyright © 2016 AlbertArroyo. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Utils.pathIOSSimulator()
        AppAppearance.install()
        
        setupWindow()
        setupInitialCoordinator()
        
        return true
    }
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
    }
    
    func setupInitialCoordinator() {
        let sceneCoordinator = SceneCoordinator(window: window!)
        let viewModel = CharactersViewModel(
            dataController: CharactersDataController(
                service: ApiService(),
                persistence: PersistenceManager()
            ),
            coordinator: sceneCoordinator
        )
        let firstScene = Scene.characters(viewModel)
        sceneCoordinator.transition(to: firstScene, type: .root)
    }

}

