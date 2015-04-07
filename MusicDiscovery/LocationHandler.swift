//
//  LocationHandler.swift
//  MusicDiscovery
//
//  Created by Dillon McCusker on 4/6/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    var latitude: String!
    var longitude: String!
    
    var gpsLocatationSet: Bool!
    
    override init() {
        locationManager = CLLocationManager()
      //  locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager = CLLocationManager()
      //  locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            locationManager.requestWhenInUseAuthorization()
            //locationManager.requestAlwaysAuthorization()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            println("location servies have already been enabled in viewDidLoad()")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        println("locations = \(locations)")
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as CLLocation
        var coord = locationObj.coordinate
        println(coord.latitude)
        println(coord.longitude)
        
        self.latitude = "\(coord.latitude)"
        self.longitude = "\(coord.longitude)"
        gpsLocatationSet = true
//        
//        latitudeLabel.textColor = UIColor.greenColor()
//        longitudeLabel.textColor = UIColor.greenColor()
//        
//        latitudeLabel.text = "\(coord.latitude)"
//        longitudeLabel.text = "\(coord.longitude)"
//        
//        gpsStatusLabel.text = "GPS\nSuccess"
//        gpsStatusLabel.textColor = UIColor.greenColor()
    }
    
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus)
    {
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        } else {
            gpsLocatationSet = false
        }
    }
}