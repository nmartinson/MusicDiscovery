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
    let toDegrees:Double = (180/M_PI)
    let toRadians:Double = (M_PI/180)
    
    let numPoints:Int = 20
    let sweepAngle:Double = 90.0
    
    var closeAngle:Double = 45.0
    var farAngle:Double = 30.0
    
    let locHandler = LocationHandler.sharedInstance
    
    let earthRad: Double = 6371000 //Earth's radius in meters

    var loc2D: CLLocationCoordinate2D!
    
    var distance: Double!
    var rawBearing: CLHeading!
    var bearing: Double!
    var startLat: Double!
    var startLong: Double!
    
    func initRadianValues() {
        loc2D = locHandler.location2D
    
        distance = 1000
        rawBearing = locHandler.bearing
//        bearing = rawBearing.magneticHeading * toRadians as Double
        bearing = rawBearing.trueHeading * toRadians as Double
        startLat  = loc2D.latitude * toRadians as Double
        startLong = loc2D.longitude * toRadians as Double
    }
    

    
    
    func calculateForwardPoints () -> [CLLocationCoordinate2D] {
       
        initRadianValues()
        
        var pointArr2D = [CLLocationCoordinate2D]()
        pointArr2D.append(loc2D)
        
        var totalPoints = Double(numPoints)
        
        for pointNum in 0...numPoints {
            var angleNum = Double(pointNum)
            var pointBearing = bearing - sweepAngle/2 * toRadians
            
//            println(bearing)
//            println(angleNum)
//            println(sweepAngle/totalPoints)
//            println(toRadians)
//            println(angleNum * (sweepAngle/angleNum) * toRadians)
            
            pointBearing = pointBearing + angleNum * (sweepAngle/totalPoints) * toRadians
//            println(pointBearing)
            var endLat = asin( sin(startLat)*cos((distance/earthRad)) +  cos(startLat)*sin(distance/earthRad)*cos(pointBearing) )
            var endLong = startLong + atan2(sin(pointBearing)*sin(distance/earthRad)*cos(startLat)
                , cos(distance/earthRad)-sin(startLat)*sin(endLat) )
            
//            println("COMPUTED FORWARD POINT")
//            println(pointBearing)
//            println(startLat)
//            println(startLong)
//            println(endLat)
//            println(endLong)
//            
//            println(pointBearing*toDegrees)
//            println(startLat*toDegrees)
//            println(startLong*toDegrees)
//            println(endLat*toDegrees)
//            println(endLong*toDegrees)
            
            pointArr2D.append( CLLocationCoordinate2DMake(endLat * toDegrees, endLong * toDegrees) )
        }
//        pointArr2D.append(loc2D)
        return pointArr2D
    }
    
//  GPS equation reference:
//    http://www.movable-type.co.uk/scripts/latlong.html
}
