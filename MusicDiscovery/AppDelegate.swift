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
    var currentUser: User?
    
    let googleMapsAPIKey = "AIzaSyDZSxaCMNiwww6VOWpFX-bpIWmeMIbi8Zo"

    let kClientId = "9267f34373fa4cb1bf9ea94246a45566"
    let kCallbackURL = "musicdiscoverylogin://callback"

    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //instantiate location handler, all other classes may now acces its sharedInstance
        locHandler = LocationHandler()
        //Set locationHandlerDelegate variable in LocationHandler so that it may call methods in the LocationAlertProtocol
        locHandler.locationHandlerDelegate = self
        
        //Google maps API Key setup
        GMSServices.provideAPIKey(googleMapsAPIKey)
        
        // configure the singleton default SPTAuth object with our clientId and callback URL
        SPTAuth.defaultInstance().clientID = kClientId
        SPTAuth.defaultInstance().redirectURL = NSURL(string: kCallbackURL)
        SPTAuth.defaultInstance().hasTokenRefreshService
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthUserReadPrivateScope]

        return true
    }
    
    
    /*******************************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * Function: getAndPushAlert
    * Input(s): 1) locAlertController: UIAlertController <<<
    * Outputs(s): Void <<<
    * Description:
    *   >>> This function takes a UIAlertController as an input parameter. The function then calls 
    *     > getVisibleViewController(...) and passes the current rootViewController at execution as an argument 
    *     > in order to determine the visible view controller.
    *     > The alert controller is then pushed to the currently visible view controller                <<<
    *******************************************************************************************************/
    func getAndPushAlert (locAlertController: UIAlertController) -> Void /*Boolean*/ {
        var rootVC = self.window?.rootViewController as UIViewController!
        var visibleVC = getVisibleViewController(rootVC)
        visibleVC.presentViewController(locAlertController, animated: true, completion: nil)
    }
    
    /*******************************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * Function: getVisibleViewController
    * Input(s): 1) rootVC: UIViewController
    * Outputs(s): 1) UIViewController
    * Description: 
    *   >>> This function takes a UIViewController as an input argument and recursively passes that view
    *     > controller back into this function until the view controller that is taken as an argument
    *     > is the view controller that is currently visible in the app. It's purpose is to allow an
    *     > an alert controller to be pushed to the current view controller from anywhere within the app. <<<
    *******************************************************************************************************/
    func getVisibleViewController(rootVC: UIViewController) -> UIViewController {
        
        var visibleVC: UIViewController!
        
        if ( rootVC.isKindOfClass(UINavigationController) ) {
            return ( getVisibleViewController( (rootVC as! UINavigationController).visibleViewController ) )
        } else if ( rootVC.isKindOfClass(UITabBarController) ) {
            return ( getVisibleViewController( (rootVC as! UITabBarController).presentedViewController! ) )
        } else {
            if ((rootVC.presentedViewController) != nil) {
                //    return [UIWindow getVisibleViewControllerFrom:vc.presentedViewController];
                return ( getVisibleViewController( (rootVC ).presentedViewController! ) )
            } else {
                return rootVC
            }
        }
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
        
        PARController.sharedARController().suspendToBackground()
        
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        PARController.sharedARController().resumeFromBackground()
        PARController.deviceSupportsAR(true)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

