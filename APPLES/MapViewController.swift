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
    func returnLocationInformation(_ info: String, latitude: String, longitude: String)
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
        doneBtn.layer.borderColor = UIColor.lightGray.cgColor
        doneBtn.backgroundColor = UIColor.white
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            map.delegate = self
            map.mapType = .standard
            map.isZoomEnabled = true
            map.isScrollEnabled = true
            
            if let coor = map.userLocation.location?.coordinate{
                map.setCenter(coor, animated: true)
            }
            addLongPressGesture()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation() // Stop Location Manager - keep here to run just once
        
        LatitudeGPS = String(format: "%.6f", manager.location!.coordinate.latitude) as NSString
        LongitudeGPS = String(format: "%.6f", manager.location!.coordinate.longitude) as NSString
        
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        centerMap(locValue)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        map.showsUserLocation = true;
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        map.showsUserLocation = false
    }
    
    func addLongPressGesture(){
        let longPressRecogniser:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target:self , action:#selector(MapViewController.handleLongPress(_:)))
        longPressRecogniser.minimumPressDuration = 1.0 //user needs to press for 2 seconds
        self.map.addGestureRecognizer(longPressRecogniser)
    }
    
    func handleLongPress(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != .began{
            return
        }
        
        let touchPoint:CGPoint = gestureRecognizer.location(in: self.map)
        let touchMapCoordinate:CLLocationCoordinate2D =
            self.map.convert(touchPoint, toCoordinateFrom: self.map)
        
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
    
    func centerMap(_ center:CLLocationCoordinate2D){
        self.saveCurrentLocation(center)
        
        let spanX = 0.007
        let spanY = 0.007
        
        let newRegion = MKCoordinateRegion(center:center , span: MKCoordinateSpanMake(spanX, spanY))
        map.setRegion(newRegion, animated: true)
    }
    
    func saveCurrentLocation(_ center:CLLocationCoordinate2D){
        let message = "\(center.latitude) , \(center.longitude)"
        print(message)
        myLocation = center
    }
    
    
    static var enable:Bool = true
    @IBAction func getMyLocation(_ sender: UIButton) {
        
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let identifier = "pin"
        var view : MKPinAnnotationView
        if let dequeueView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView{
            dequeueView.annotation = annotation
            view = dequeueView
        }
        else{
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.pinTintColor =  UIColor.red
        return view
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func doneBtnClicked(_ sender: AnyObject) {

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
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
