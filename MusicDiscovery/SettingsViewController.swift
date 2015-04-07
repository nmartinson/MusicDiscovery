//
//  SettingsViewController.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 4/2/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class SettingsViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate
{
    @IBOutlet weak var searchField: UITextField!
    var request:NSURL?
    var session:SPTSession!
    
    var appDelegate: AppDelegate!

    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var locationFixAchieved : Bool = false
    var locationStatus : String = "Not Started"
    
    override func viewDidLoad() {
        if let sessionObj:AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("SpotifySession")
        {
            // convert the stored session object back to SPTSession
            let sessionData = sessionObj as NSData
            session = NSKeyedUnarchiver.unarchiveObjectWithData(sessionData) as SPTSession
            
            appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate!
            
        }
        
//        if appDelegate != nil {
//            appDelegate.initLocationManager()
//        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        initLocationManager()
        
//        if CLLocationManager.authorizationStatus() == .NotDetermined {
//            locationManager.requestWhenInUseAuthorization()
//            //locationManager.requestAlwaysAuthorization()
//        }
//        
//        if CLLocationManager.locationServicesEnabled() {
//            println("location servies have already been enabled in viewDidLoad()")
//            locationManager.startUpdatingLocation()
//        }
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
            //locationManager.requestAlwaysAuthorization()
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
            self.presentViewController(alertController, animated: true, completion: nil)
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
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if searchField.text != nil
        {
            let text = searchField.text.stringByReplacingOccurrencesOfString(" ", withString: "-")
            println("session \(session)")

            SPTRequest.performSearchWithQuery(text, queryType: SPTSearchQueryType.QueryTypeTrack, offset: 0, session: session) { (error, response) -> Void in
                if response != nil
                {
                    let items = response.items!
                    let first = items[0] as SPTPartialTrack
                    self.request = first.playableUri
                    println(first)
                }
            }
        }
        
        return true
    }
    
    @IBAction func playButtonPressed(sender: UIButton)
    {
        println("request \(request)")
        println("session \(session)")
        AppDelegate().playUsingSession(session, request: request!)
    }
}