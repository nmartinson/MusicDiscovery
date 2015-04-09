


import UIKit



class MapViewController: UIViewController, MapUpdateProtocol, LocationNotificationProtocol, LocationAlertProtocol {
    
    let locHandler = LocationHandler.sharedInstance
    
    @IBOutlet weak var mapView: GMSMapView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        locHandler.locationHandlerDelegate = self
        locHandler.mapUpdateDelgate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        locHandler.locNotificationDelegate = self
        notifyLocationHandler()
    }
    
    func notifyLocationHandler () -> Void {
        locHandler.mapViewExists = true
    }
    
    func checkMapExistence() -> Bool {
        if mapView != nil {
            return true
        }
        return false
    }
    
    func setMapLocation (CLLocationCoordinate2D) -> Bool {
        
        if mapView != nil {
            mapView.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 30, bearing: 0, viewingAngle: 0)
            mapView.mapType = kGMSTypeNormal
            return true
        }
        return false
    }
    
    func getAndPushAlert (locationAlert: UIAlertController) -> Void {
        self.presentViewController(locationAlert, animated: true, completion: nil)
    }
    
//    func updateMap() {
//        println("Updating map")
//        
//        mapView.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 30, bearing: 0, viewingAngle: 0)
//        mapView.mapType = kGMSTypeNormal
//    }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

  }

}

