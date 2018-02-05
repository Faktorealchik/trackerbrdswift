//
//  AppDelegate.swift
//  trackerbrd
//
//  Created by Alexandr Nesterov on 1/16/18.
//  Copyright © 2018 Alexandr Nesterov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        
        let userDefaults = UserDefaults(suiteName: "ru.buyitfree")
        let token = userDefaults?.string(forKey: "token")
        let remember = userDefaults?.bool(forKey: "rememberMe")
        let type = userDefaults?.integer(forKey: "type")
        if token != nil && type != nil && remember != nil && remember! {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let rootVC = storyboard.instantiateViewController(withIdentifier: "FirstNavigationController")
            var initialViewController: UIViewController
            if type == 1 {
                initialViewController = storyboard.instantiateViewController(withIdentifier: "Driver")
            } else {
                initialViewController = storyboard.instantiateViewController(withIdentifier: "Manager")
            }
            self.window?.rootViewController = rootVC
            self.window?.makeKeyAndVisible()
            rootVC.present(initialViewController, animated: false)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

