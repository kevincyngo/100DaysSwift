//
//  AppDelegate.swift
//  Project7
//
//  Created by Kevin Ngo on 2020-03-22.
//  Copyright © 2020 Kevin Ngo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //our storyboard automatically creates a window in which all our VCs are shown
    
    //In the Single View App template, the root view controller is the ViewController,
    //but we embedded ours inside a navigation controller, then embedded that inside a tab bar controller.
    //So, for us the root view controller is a UITabBarController.
    
    var window: UIWindow?
    
    //gets called by iOS when the app has finished loading and is ready to be used
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let tabBarController = window?.rootViewController as? UITabBarController {
            //Need to create a new VC by hand, which means we need to get reference to Main.storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "NavController")
            vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
            //add the new VC to our tab bar controller's viewControllers array, which will cause it to appear in the tab vbar
            tabBarController.viewControllers?.append(vc)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

