  //
//  AppDelegate.swift
//  For Hire
//
//  Created by Christian Ayscue on 2/11/15.
//  Copyright (c) 2015 coayscue. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        application.statusBarStyle = UIStatusBarStyle.LightContent
        
        Parse.enableLocalDatastore()
        
        //set up link to Parse
        Parse.setApplicationId("JspHuKQqf2O3iSxqYAjRB36IWry4i4ajeVSJDIhX",
            clientKey: "VSIyaFRXkrwZQswG8pu8x8zDO0t9Qdh0FGyGfyZv")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptionsInBackground(launchOptions, block: { (blah, error) -> Void in
        })
        
        //NSUserDefaults.standardUserDefaults().setBool(false, forKey: "entered")
        
        return true
    }

    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

//        var entered: Bool = NSUserDefaults.standardUserDefaults().boolForKey("entered")
//        
//            if !entered {
//                var revealController = self.window!.rootViewController as! SWRevealViewController
//                let mainStoryboard: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
//                var lockViewController = mainStoryboard.instantiateViewControllerWithIdentifier("entrance") as! EntranceViewController
//                revealController.presentViewController(lockViewController, animated: false, completion: nil)
//            }
//        
        //checks for the matching version numbers (this will run if the new version has not been run before
        var userDefaults = NSUserDefaults.standardUserDefaults()
        
        if var version = userDefaults.valueForKey("Version") as? Double{
            if version != 1.1 {
                // Adding version number to NSUserDefaults for first version:
                userDefaults.setDouble(1.1, forKey: "Version")
                println("open")
                
                // jump to instructions page
                var mainVC = self.window!.rootViewController!
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                var introVC = mainStoryboard.instantiateViewControllerWithIdentifier("IntroVC") as! UINavigationController
                mainVC.presentViewController(introVC, animated: false, completion: nil)
            }
        }else{
                // Adding version number to NSUserDefaults for first version:
                userDefaults.setDouble(1.1, forKey: "Version")
                println("open")
                
                // jump to instructions page
                var mainVC = self.window!.rootViewController!
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "MainStoryboard", bundle: nil)
                var introVC = mainStoryboard.instantiateViewControllerWithIdentifier("IntroVC") as! UINavigationController
                mainVC.presentViewController(introVC, animated: false, completion: nil)
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

