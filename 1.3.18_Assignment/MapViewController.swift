//
//  ViewController.swift
//  1.3.18_Assignment
//
//  Created by Kevin Yan on 1/3/18.
//  Copyright © 2018 Kevin Yan. All rights reserved.
//

//AIzaSyB2d1OBcEjvh98TbfquvuxGWvIErOUIRKc
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{
    var locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func getCoordinates(_ sender: UIButton) {
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)        
    }
}

//let span2 = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
//let location2: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.732111, longitude: -122.398792)
//let region2 = MKCoordinateRegion(center: location2, span: span2)
//mapView.setRegion(region2, animated: true)
