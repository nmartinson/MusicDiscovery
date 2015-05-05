//
//  UserPreferences.swift
//  MusicDiscovery
//
//  Created by Nick Martinson on 5/4/15.
//  Copyright (c) 2015 Nick Martinson. All rights reserved.
//

import Foundation

class UserPreferences
{
    func getRadius() -> Int
    {
        return NSUserDefaults.standardUserDefaults().integerForKey("searchRadius")
    }
    
    func isVisible() -> Bool
    {
        return NSUserDefaults.standardUserDefaults().boolForKey("visibility")
    }
    
    
}