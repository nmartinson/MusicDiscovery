


import UIKit



class MapViewController: UIViewController, MapUpdateProtocol, LocationNotificationProtocol, LocationAlertProtocol {
    
    let locHandler = LocationHandler.sharedInstance
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let calculator: MapCalculator! = MapCalculator()
    
    var currentMapType: GMSMapViewType = kGMSTypeNormal
    
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
    
    func updateMapView () -> Void {
        if locHandler.bearing != nil {
            var magneticBearing = locHandler.bearing.magneticHeading
            if mapView != nil {
                
                mapView.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 30, bearing: magneticBearing, viewingAngle: 0)
                mapView.mapType = currentMapType
            }
        }
    }
    
    func setMapLocation () -> Bool {
        
        if mapView != nil {
            mapView.camera = GMSCameraPosition(target: locHandler.location2D, zoom: 30, bearing: 0, viewingAngle: 0)
            mapView.mapType = currentMapType
//            drawPolygon()
//            calculator.calculatePoint()
            
            return true
        }
        return false
    }
    
    func getAndPushAlert (locationAlert: UIAlertController) -> Void {
        self.presentViewController(locationAlert, animated: true, completion: nil)
    }
    
    //This is only a test function
    func drawPolygon () -> Void {
        // Create a rectangular path
        var rect = GMSMutablePath()
        rect.addCoordinate(CLLocationCoordinate2DMake(37.36, -122.0))
        rect.addCoordinate(CLLocationCoordinate2DMake(37.45, -122.0))
        rect.addCoordinate(CLLocationCoordinate2DMake(37.45, -122.2))
        rect.addCoordinate(CLLocationCoordinate2DMake(37.36, -122.2))
        
        // Create the polygon, and assign it to the map.
        var polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red:0.25, green:0, blue:0, alpha:0.05)
        polygon.strokeColor = UIColor.blackColor()
        polygon.strokeWidth = 2
        polygon.map = mapView

    }
    


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }

}

