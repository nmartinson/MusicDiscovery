//
//  LocationHandler.swift
//  MusicDiscovery
//
//  Created by Dillon McCusker on 4/6/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

private let _LocationHandlerSharedInstance = LocationHandler()

protocol LocationAlertProtocol{
    func getAndPushAlert (UIAlertController) -> Void
}

protocol MapUpdateProtocol{
    func setMapLocation () -> Bool
    func updateMapView () -> Void
    func checkMapExistence() -> Bool
}

protocol LocationNotificationProtocol{
    func notifyLocationHandler () -> Void
}

class LocationHandler: NSObject, CLLocationManagerDelegate{

    class var sharedInstance: LocationHandler {
        return _LocationHandlerSharedInstance
    }
    
    var locNotificationDelegate: LocationNotificationProtocol!
    
    var mapUpdateDelgate: MapUpdateProtocol!
    
    var mapSetup: Bool = false
    
    var locationHandlerDelegate: LocationAlertProtocol!
    
    var locationManager: CLLocationManager!
    
    var latitude: String!
    var longitude: String!
    var location2D: CLLocationCoordinate2D!
    
    //This variable holds the direction to which the device is pointed in degrees
    var bearing: CLHeading!
    
    var gpsLocatationSet: Bool!
    
    var mapViewExists: Bool = false
    
    var seenError = false
    
    /*********************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * This initializer sets up CoreLocation services.
    **********************************************************************************************/
    override init() {
        super.init()
        println("location handler init")
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    

    /*********************************************************************************************
    * 4/15/2015
    * Author: Dillon McCusker
    * function: locationManager
    * Input(s): 
    *    1) CLLocationManager
    *    2) CLHeading <<<
    * Outputs: Void <<<
    * Description:
    *   >>> This function is called when the CLHeading is updated, meaning magnetnic direction has
    *     > likely changed. <<<
    **********************************************************************************************/
    func locationManager(manager: CLLocationManager!,
        didUpdateHeading newHeading: CLHeading!) {
        
        println("Udated Heading")
        println("\t\(newHeading)")
            
        if mapSetup && mapViewExists {
            mapUpdateDelgate.updateMapView()
        }

    }

    /*********************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * This function is called when CLLocationManager updates current location in the background.
    * TODO: Handle new coordinate data here.
    **********************************************************************************************/
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        //println("locations = \(locations)")
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
//        self.bearing = locationObj.course as CLLocationDirection
        //        println(coord.latitude)
//        println(coord.longitude)
        
        self.location2D = coord
        self.latitude = "\(coord.latitude)"
        self.longitude = "\(coord.longitude)"
        gpsLocatationSet = true
        
        //setup the mapview and cameraposition for the first time
        if !mapSetup && mapViewExists  {
            if mapUpdateDelgate.setMapLocation() {
                mapSetup = true
            }
        }
        //update the map's camera position
        if mapSetup && mapViewExists {
            mapUpdateDelgate.updateMapView()
        }
    }
    
    func compassInit() -> Void {
       
        locationManager.startUpdatingHeading()
        
        
        if CLLocationManager.headingAvailable() == false {
            //need alertController for this
            println("This device does not have the ability to measure magnetic fields.")
        } else {
            //            locationManager.headingFilter = ? //The default value of this property is 1 degree
            //            locationManager.headingOrientation = ? // https://developer.apple.com/library/prerelease/ios/documentation/CoreLocation/Reference/CLLocationManager_Class/index.html#//apple_ref/occ/instp/CLLocationManager/headingOrientation
            locationManager.startUpdatingHeading()
        }
        
//        if locationManager.headingAvailable {
//            
//        }
        
        
        //    // check if the hardware has a compass
        //    if ([CLLocationManager headingAvailable] == NO) {
        //    // No compass is available. This application cannot function without a compass,
        //    // so a dialog will be displayed and no magnetic data will be measured.
        //    self.locationManager = nil;
        //    UIAlertView *noCompassAlert = [[UIAlertView alloc] initWithTitle:@"No Compass!"
        //    message:@"This device does not have the ability to measure magnetic fields."
        //    delegate:nil
        //    cancelButtonTitle:@"OK"
        //    otherButtonTitles:nil];
        //    [noCompassAlert show];
        //    } else {
        //    // heading service configuration
        //    self.locationManager.headingFilter = kCLHeadingFilterNone;
        //
        //    // setup delegate callbacks
        //    self.locationManager.delegate = self;
        //    
        //    // start the compass
        //    [self.locationManager startUpdatingHeading];
        //    }
    }
    
    
    
    /*********************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * This function is called when authorization status changes in CLLocationManager.
    **********************************************************************************************/
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        switch status {
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
//            locationManager.requestWhenInUseAuthorization()
            println("authorizationSatus is .NotDetermined at initLocationManager()")
        case .Restricted:
            println("authorizationSatus is .Restricted at initLocationManager()")
        case .Denied:
            println("authorizationSatus is .Denied at initLocationManager()")
            ////Use function in protocol to push the alert about location settings
            var locServicesAlertController: UIAlertController = buildTurnOnLocationAlertController()
            locationHandlerDelegate.getAndPushAlert(locServicesAlertController)
        case .AuthorizedAlways:
            println("authorizationSatus is .AuthorizedAlways at initLocationManager()")
        case .AuthorizedWhenInUse:
          println("authorizationSatus is .AuthorizedWhenInUse at initLocationManager()")
//            var locServicesAlertController: UIAlertController = buildAuthAlwaysAlertController()
//            locationHandlerDelegate.getAndPushAlert(locServicesAlertController)
        default:
            println("did not find a matching auth in switch statement")
        }
        

        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            //Start up dating location and magnetic heading
            self.compassInit()
            locationManager.startUpdatingLocation()
        } else {
            gpsLocatationSet = false
        }
    }
    
    /*********************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * This function is provided by CLLocationManager. It will be called when location services 
    * fail with error.
    * Function stops location updates and prints an error, one time.
    **********************************************************************************************/
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }

    /*********************************************************************************************
    * 4/7/2015
    * Author: Dillon McCusker
    * Function returns an alertController that may be pushed in a view controller.
    **********************************************************************************************/
    func buildTurnOnLocationAlertController() -> UIAlertController {
        
        let alertController = UIAlertController(
            title: "Turn On Location Services",
            message: "You must turn on Location Services in Settings > Privacy > Location Services to use this app.",
            preferredStyle: .Alert
        )
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        let openAction = UIAlertAction(title: "Open App Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        return alertController
    }
    
    /*********************************************************************************************
    * 4/7/2015
    * Author: Dillon McCusker
    * Function returns an alertcontroller that may be pushed in a view controller.
    **********************************************************************************************/
    func buildAuthAlwaysAlertController() -> UIAlertController {
        
        let alertController = UIAlertController(
            title: "Background Location Access Disabled",
            message: "To use this app and discover music near you, please open this app's settings and set location access to 'Always'.",
            preferredStyle: .Alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
                let openAction = UIAlertAction(title: "Open App Settings", style: .Default) { (action) in
            if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
        alertController.addAction(openAction)
        return alertController
    }
}