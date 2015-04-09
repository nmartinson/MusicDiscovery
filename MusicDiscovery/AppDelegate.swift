//
//  AppDelegate.swift
//  SpotifyTest
//
//  Created by Nick Martinson on 4/1/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, LocationAlertProtocol {
    
    var window: UIWindow?
    
    var locHandler: LocationHandler!
    
    let googleMapsAPIKey = "AIzaSyDZSxaCMNiwww6VOWpFX-bpIWmeMIbi8Zo"

    let kClientId = "9267f34373fa4cb1bf9ea94246a45566"
    let kCallbackURL = "musicdiscoverylogin://callback"

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        locHandler = LocationHandler()
        locHandler.locationHandlerDelegate = self
        
        //Google maps API
        //[GMSServices provideAPIKey:@"API_KEY"];
        GMSServices.provideAPIKey(googleMapsAPIKey)
        
        // configure the singleton default SPTAuth object with our clientId and callback URL
        SPTAuth.defaultInstance().clientID = kClientId
        SPTAuth.defaultInstance().redirectURL = NSURL(string: kCallbackURL)
        SPTAuth.defaultInstance().hasTokenRefreshService
        
        return true
    }
    
    func getAndPushAlert (locAlertController: UIAlertController) -> Void /*Boolean*/ {
//        self.window?.rootViewController.pushViewController( locAlertController, animated: true)
        var rootVC = self.window?.rootViewController as UIViewController!
        var visibleVC = getVisibleViewController(rootVC)
        visibleVC.presentViewController(locAlertController, animated: true, completion: nil)
    }
    
    
    func getVisibleViewController(rootVC: UIViewController) -> UIViewController {
        
        var visibleVC: UIViewController!
        
        if ( rootVC.isKindOfClass(UINavigationController) ) {
            return ( getVisibleViewController( (rootVC as UINavigationController).visibleViewController ) )
        } else if ( rootVC.isKindOfClass(UITabBarController) ) {
            return ( getVisibleViewController( (rootVC as UITabBarController).presentedViewController! ) )
        } else {
            if ((rootVC.presentedViewController) != nil) {
                //    return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
                return ( getVisibleViewController( (rootVC ).presentedViewController! ) )
            } else {
                return rootVC
            }
        }
        
        //    if ([vc isKindOfClass:[UINavigationController class]]) {
        //    return [UIWindow getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
        //    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        //    return [UIWindow getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
        //    } else {
        //    if (vc.presentedViewController) {
        //    return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
        //    } else {
        //    return vc;
        //    }
        //    }

    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        return false
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
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

