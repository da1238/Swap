//
//  AppDelegate.swift
//  SwapNote
//
//  Created by David Abraham on 12/11/17.
//  Copyright © 2017 David Abraham. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseAuth
import FacebookLogin
import FacebookCore
import FirebaseFirestore
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate{
    
    var window: UIWindow?
    var databaseRef: DatabaseReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Hide Status Bar
        UIApplication.shared.isStatusBarHidden = false
        
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
 
        // Facebook Login
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Remain signed in
        if Auth.auth().currentUser != nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialVC:UITabBarController = storyboard.instantiateViewController(withIdentifier: "dashboardView") as! UITabBarController
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = initialVC
            self.window?.makeKeyAndVisible()
        }
        
    
        // NavBar customization
        
//        UIApplication.shared.statusBarStyle = .lightContent
//        UINavigationBar.appearance().barTintColor = UIColor(red:0.32, green:0.42, blue:0.29, alpha:1.0)
        UINavigationBar.appearance().tintColor = UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0)
        UITabBar.appearance().tintColor = UIColor(red:0.00, green:0.80, blue:0.61, alpha:1.0)
//        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
//        UINavigationBar.appearance().isTranslucent = false

        
        return true
    }


    private func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> (Bool, Bool) {
        
        return (SDKApplicationDelegate.shared.application(app, open: url, options:options),
                GIDSignIn.sharedInstance().handle(url,
                                                  sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                  annotation: [:]))
        
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
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
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is NewNoteViewController {
            if let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "uploadNote") {
                tabBarController.present(newVC, animated: true)
                return false
            }
        }
        
        return true
    }
    
        
}

