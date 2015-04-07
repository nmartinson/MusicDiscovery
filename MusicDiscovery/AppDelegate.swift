//
//  AppDelegate.swift
//  SpotifyTest
//
//  Created by Nick Martinson on 4/1/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : String = "Not Started"
    
    let kClientId = "9267f34373fa4cb1bf9ea94246a45566"
    let kCallbackURL = "musicdiscoverylogin://callback"
    var session:SPTSession?
    var player:SPTAudioStreamingController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // configure the singleton default SPTAuth object with our clientId and callback URL
        SPTAuth.defaultInstance().clientID = kClientId
        SPTAuth.defaultInstance().redirectURL = NSURL(string: kCallbackURL)
        
        return true
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool
    {
        println("OPEN URL")
        // check if the url is a valid spotify url
        if SPTAuth.defaultInstance().canHandleURL(url)
        {
            SPTAuth.defaultInstance().handleAuthCallbackWithTriggeredAuthURL(url, callback: { (error, session) -> Void in
                if error != nil { println("error \(error)") }
                else
                {
                    self.session = session
                    // request the current users information
                    SPTRequest.userInformationForUserInSession(session, callback: { (error, user) -> Void in
                        let name = user.displayName
                        println(name)
                    })
                }
                
                // store the session data in user defaults
                let defaults = NSUserDefaults.standardUserDefaults()
                let sessionData = NSKeyedArchiver.archivedDataWithRootObject(session!)
                defaults.setObject(sessionData, forKey: "SpotifySession")
//                self.playUsingSession(session)
            })
        }
        
        return false
    }
    
    // Test for playing a random song from an album URI i found
    func playUsingSession(session:SPTSession, request: NSURL)
    {
        // if the player is nil, initialize it with the clientID
        if self.player == nil { self.player = SPTAudioStreamingController(clientId: kClientId) }
        self.player?.loginWithSession(session, callback: { (error) -> Void in
            
            if error != nil { println("Playback error \(error)") }
            else
            {
                println("player login")
                //                SPTRequest.requestItemAtURI(request, withSession: session, callback: { (error, album) -> Void in
                //                    if error != nil
                //                    {
                //                        println("Album error")
                //                    }
                //                    else
                //                    {
                //                        var item = (album as SPTTrack).playableUri
                //                        println(item)
                self.player?.playURIs([request], fromIndex: 0, callback: { (error) -> Void in
                    if error != nil
                    {
                        println("Playback error \(error)")
                    }
                })
                //                    }
                //                })
            }
        })
    }
    
    // Location Manager helper stuff
    func initLocationManager() {
        seenError = false
        locationFixAchieved = false
        locationManager = CLLocationManager()
        locationManager.delegate = self
        var status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
            println("authorizationSatus is .NotDetermined at initLocationManager()")
        case .Restricted:
            println("authorizationSatus is .Restricted at initLocationManager()")
        case .Denied:
            println("authorizationSatus is .Denied at initLocationManager()")
        case .AuthorizedAlways:
            println("authorizationSatus is .AuthorizedAlways at initLocationManager()")
        case .AuthorizedWhenInUse:
            println("authorizationSatus is .AuthorizedWhenInUse at initLocationManager()")
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about adorable kittens near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert
            )
        
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
        
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            self.window?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
        default:
            println("did not find a matchin auth in switch statement")
        }
        
//        if CLLocationManager.authorizationStatus() == .NotDetermined {
//            NSLog("Location Auth undetermined, requesting authorization")
//            locationManager.requestWhenInUseAuthorization()
//            //locationManager.requestAlwaysAuthorization()
//        }
        
        if CLLocationManager.locationServicesEnabled() {
            NSLog("Location services are enabled at launch")
            println("\t \(CLLocationManager.authorizationStatus().rawValue)" )
            locationManager.startUpdatingLocation()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // Location Manager Delegate stuff
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if (locationFixAchieved == false) {
            locationFixAchieved = true
            var locationArray = locations as NSArray
            var locationObj = locationArray.lastObject as CLLocation
            var coord = locationObj.coordinate
            
            println(coord.latitude)
            println(coord.longitude)
        }
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            var shouldIAllow = false

            if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
                locationManager.startUpdatingLocation()
                NSLog("Location services enabled")
            } else {
                NSLog("Location services are not enabled")
                //gpsLocatationSet = false
            }
            
//            switch status {
//            case CLAuthorizationStatus.Restricted:
//                locationStatus = "Restricted Access to location"
//            case CLAuthorizationStatus.Denied:
//                locationStatus = "User denied access to location"
//            case CLAuthorizationStatus.NotDetermined:
//                locationStatus = "Status not determined"
//            default:
//                locationStatus = "Allowed to location Access"
//                shouldIAllow = true
//            }
//            NSNotificationCenter.defaultCenter().postNotificationName("LabelHasbeenUpdated", object: nil)
//            if (shouldIAllow == true) {
//                NSLog("Location to Allowed")
//                // Start location services
//                locationManager.startUpdatingLocation()
//            } else {
//                NSLog("Denied access: \(locationStatus)")
//            }
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

