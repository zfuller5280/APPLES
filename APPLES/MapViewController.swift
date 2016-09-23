//
//  MapViewController.swift
//  APPLES
//
//  Created by Steve Schaeffer on 7/5/16.
//  Copyright © 2016 Zach Fuller. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol locationInformation: class {
    func returnLocationInformation(info: String, latitude: String, longitude: String)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var map: MKMapView!

    @IBOutlet weak var doneBtn: UIButton!
    
    var LatitudeGPS = NSString()
    var LongitudeGPS = NSString()
    var myLocation:CLLocationCoordinate2D?
    
    var location = CLLocation()
    
    weak var delegate: locationInformation? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneBtn.layer.cornerRadius = 4.0
        doneBtn.layer.borderWidth = 2.0
        doneBtn.layer.borderColor = UIColor.lightGrayColor().CGColor
        doneBtn.backgroundColor = UIColor.whiteColor()
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            map.delegate = self
            map.mapType = .Standard
            map.zoomEnabled = true
            map.scrollEnabled = true
            
            if let coor = map.userLocation.location?.coordinate{
                map.setCenterCoordinate(coor, animated: true)
            }
            addLongPressGesture()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation() // Stop Location Manager - keep here to run just once
        
        LatitudeGPS = String(format: "%.6f", manager.location!.coordinate.latitude)
        LongitudeGPS = String(format: "%.6f", manager.location!.coordinate.longitude)
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        map.showsUserLocation = true;
    }
    
    override func viewWillDisappear(animated: Bool) {
        map.showsUserLocation = false
    }
    
    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
        self.map.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .Began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.locationInView(self.map)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
        
        let annot:MKPointAnnotation = MKPointAnnotation()
        annot.coordinate = touchMapCoordinate
        
        self.resetTracking()
        self.map.addAnnotation(annot)
        self.centerMap(touchMapCoordinate)
    }
    
    func resetTracking(){
        if (map.showsUserLocation){
            map.showsUserLocation = false
            self.map.removeAnnotations(map.annotations)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
    func centerMap(center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        map.setRegion(newRegion, animated: true)
    }
    
    func saveCurrentLocation(center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        myLocation = center
    }
    
    
    static var enable:Bool = true
    @IBAction func getMyLocation(sender: UIButton) {
        
        if CLLocationManager.locationServicesEnabled() {
            if MapViewController.enable {
                locationManager.stopUpdatingHeading()
                sender.titleLabel?.text = "Enable"
            }else{
                locationManager.startUpdatingLocation()
                sender.titleLabel?.text = "Disable"
            }
            MapViewController.enable = !MapViewController.enable
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
            dequeueView.annotation = annotation
            view = dequeueView
        }
        else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        view.pinTintColor =  UIColor.redColor()
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneBtnClicked(sender: AnyObject) {

        let location = CLLocation(latitude: (self.myLocation?.latitude)!, longitude: (self.myLocation?.longitude)!)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            print(self.location)
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                
                let locale = pm.locality
                let locCountry = pm.country
                let state = pm.addressDictionary!["State"] as? NSString

                //print(locale, locCountry, state)
                let locationInfo = ("\(locale!), \(state!), \(locCountry!)")
                self.delegate?.returnLocationInformation(locationInfo, latitude: self.LatitudeGPS as String, longitude: self.LongitudeGPS as String)
                //print(locationInfo)
            
            }
            else {
                print("Problem with the data received from geocoder")
            }
            })
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
