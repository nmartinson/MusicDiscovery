//
//  MapHandler.swift
//  MusicDiscovery
//
//  Created by Dillon McCusker on 4/9/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation
import UIKit

private let _mapHandlerSharedInstance = MapHandler()

class MapHandler: GMSMapView, GMSMapViewDelegate {
    
    let locHandler = LocationHandler.sharedInstance
    
    class var sharedInstance: MapHandler {
        return _mapHandlerSharedInstance
    }
    
//    override init() {
//        
//    }
//
//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    var mapRadius: Double {
        get {
            let region = self.projection.visibleRegion()
            let verticalDistance = GMSGeometryDistance(region.farLeft, region.nearLeft)
            let horizontalDistance = GMSGeometryDistance(region.farLeft, region.farRight)
            return max(horizontalDistance, verticalDistance)*0.5
        }
    }

    func updateMap() {
//        println("Updating map")
//        self.myLocationEnabled = true
//        self.settings.myLocationButton = true
//        
//        
//        self.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 15, bearing: 0, viewingAngle: 0)
//        self.mapType = kGMSTypeNormal
    }
}
