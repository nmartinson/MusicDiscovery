//
//  MapViewController.swift
//  Feed Me
//
//  Created by Ron Kliffer on 8/30/14.
//  Copyright (c) 2014 Ron Kliffer. All rights reserved.
//

//import UIKit
//
//class MapViewController: UIViewController, TypesTableViewControllerDelegate {
//  
//  @IBOutlet weak var mapCenterPinImage: UIImageView!
//  @IBOutlet weak var pinImageVerticalConstraint: NSLayoutConstraint!
//  var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
//  
//  override func viewDidLoad() {
//    super.viewDidLoad()
//    // Do any additional setup after loading the view, typically from a nib.
//  }
//  
//  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    if segue.identifier == "Types Segue" {
//      let navigationController = segue.destinationViewController as UINavigationController
//      let controller = segue.destinationViewController.topViewController as TypesTableViewController
//      controller.selectedTypes = searchedTypes
//      controller.delegate = self
//    }
//  }
//  
//  // MARK: - Types Controller Delegate
//  func typesController(controller: TypesTableViewController, didSelectTypes types: [String]) {
//    searchedTypes = sorted(controller.selectedTypes)
//    dismissViewControllerAnimated(true, completion: nil)
//  }
//}

