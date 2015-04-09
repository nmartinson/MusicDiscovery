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

class LocationHandler: NSObject, CLLocationManagerDelegate {

    class var sharedInstance: LocationHandler {
        return _LocationHandlerSharedInstance
    }
    
    var locationHandlerDelegate: LocationAlertProtocol!
    
    var locationManager: CLLocationManager!
    
    var latitude: String!
    var longitude: String!
    
    var location2D: CLLocationCoordinate2D!
    
    var gpsLocatationSet: Bool!
    
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
        //The lines below needs more research.
//        locationManager.pausesLocationUpdatesAutomatically = true
//        locationManager.distanceFilter = //typealias CLLocationDistance = Double --> give it a Double value
        
//        if CLLocationManager.authorizationStatus() == .NotDetermined {
//            println(".NotDetermined")
//            locationManager.requestWhenInUseAuthorization()
//        }
        
//        if CLLocationManager.locationServicesEnabled() {
//            println("Location services enabled at init")
//            locationManager.startUpdatingLocation()
//        } else {
//            println("Location disabled at init")
//            var locServicesAlertController: UIAlertController = buildAuthAlwaysAlertController()
//            //use protocol to push the alert
//        }

    }

    /*********************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * This function is called when CLLocationManager updates current location in the background.
    * TODO: Handle new coordinate data here.
    **********************************************************************************************/
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        println("locations = \(locations)")
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
        println(coord.latitude)
        println(coord.longitude)
        
        self.location2D = coord
        self.latitude = "\(coord.latitude)"
        self.longitude = "\(coord.longitude)"
        gpsLocatationSet = true
        
//        MapHandler.sharedInstance.updateMap()
        if MapViewController.sharedInstance.mapView != nil {
            MapViewController.sharedInstance.updateMap()
            locationManager.stopUpdatingLocation()
        }

    }
    
    /*********************************************************************************************
    * 4/6/2015
    * Author: Dillon McCusker
    * This function is called when authorization status changes in CLLocationManager.
    **********************************************************************************************/
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
//        var status = CLLocationManager.authorizationStatus()
        switch status {
        case .NotDetermined:
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            println("authorizationSatus is .NotDetermined at initLocationManager()")
        case .Restricted:
            println("authorizationSatus is .Restricted at initLocationManager()")
        case .Denied:
            println("authorizationSatus is .Denied at initLocationManager()")
            var locServicesAlertController: UIAlertController = buildTurnOnLocationAlertController()
            locationHandlerDelegate.getAndPushAlert(locServicesAlertController)
            //use protocol to push the alert
        case .AuthorizedAlways:
            println("authorizationSatus is .AuthorizedAlways at initLocationManager()")
        case .AuthorizedWhenInUse:
            println("authorizationSatus is .AuthorizedWhenInUse at initLocationManager()")
            var locServicesAlertController: UIAlertController = buildAuthAlwaysAlertController()
            locationHandlerDelegate.getAndPushAlert(locServicesAlertController)
        default:
            println("did not find a matching auth in switch statement")
        }
        
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
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
        locationManager.stopUpdatingLocation()
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
    * Function returns an alertcontroller that may be pushed in a view controller.
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