//
//  MapCalculator.swift
//  MusicDiscovery
//
//  Created by Dillon McCusker on 4/15/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import Darwin

class MapCalculator {
    
    let locHandler = LocationHandler.sharedInstance
    
    let earthRad: Double = 6371 //Earth's radius in meters
    
    func calculatePoint () {
        var loc2D = locHandler.location2D
        
        var distance: Double = 500//500 meters
        var bearing: Double = locHandler.bearing as Double
        var startLat: Double  = loc2D.latitude
        var startLong: Double = loc2D.longitude
        
        var endLat = asin( sin(startLat)*cos((distance/earthRad)) +  cos(startLat)*sin(distance/earthRad)*cos(bearing) )
        var endLong = startLong + atan( (cos(distance/earthRad)-sin(startLat)*sin(endLat))
                / (sin(bearing)*sin(distance/earthRad)*cos(startLat)) )
        
        println(startLat)
        println(startLong)
        println(endLat)
        println(endLong)
        
//    lon2: =lon1 + ATAN2(COS(d/R)-SIN(lat1)*SIN(lat2), SIN(brng)*SIN(d/R)*COS(lat1))
    }
    
    //    var φ2 = Math.asin( Math.sin(φ1)*Math.cos(d/R) +
    //        Math.cos(φ1)*Math.sin(d/R)*Math.cos(brng) );
    //    var λ2 = λ1 + Math.atan2(Math.sin(brng)*Math.sin(d/R)*Math.cos(φ1),
    //        Math.cos(d/R)-Math.sin(φ1)*Math.sin(φ2));
    
    //    func updateMap() {
    //        println("Updating map")
    //
    //        mapView.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 30, bearing: 0, viewingAngle: 0)
    //        mapView.mapType = kGMSTypeNormal
    //    }
    
//    lat2: =ASIN(SIN(lat1)*COS(d/R) + COS(lat1)*SIN(d/R)*COS(brng))
//    lon2: =lon1 + ATAN2(COS(d/R)-SIN(lat1)*SIN(lat2), SIN(brng)*SIN(d/R)*COS(lat1))
//    http://www.movable-type.co.uk/scripts/latlong.html
}
