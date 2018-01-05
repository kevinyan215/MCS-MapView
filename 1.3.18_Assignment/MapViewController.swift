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
//    var places: [Response] = []
    let networkManager = NetworkManager()

    @IBOutlet weak var mapView: MKMapView!
    @IBAction func getCoordinates(_ sender: UIButton) {
//        networkManager.downloadLocations()
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        networkManager.delegate = self

        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
        let centerCoord: CLLocationCoordinate2D = mapView.centerCoordinate
        networkManager.downloadLocations(lat: centerCoord.latitude, lng: centerCoord.longitude)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("update location")
        let location = locations[0]
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        manager.stopUpdatingLocation()
    }
}

extension MapViewController: NetworkManagerDelegate {
    func didDownload(response: Response) {
        mapView.removeAnnotations(mapView.annotations)
        
        for place in response.results {
            guard let lat = place.geometry?.location?.lat, let lng = place.geometry?.location?.lng else {
                continue
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
            annotation.title = place.name
            mapView.addAnnotation(annotation)
        }
    }
}

class NetworkManager {
    var delegate: NetworkManagerDelegate?
    func downloadLocations(lat: Double, lng: Double) {
//        let lat:Double = -33.8670522
//        let lng: Double = 151.1957362
        
        let urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=500&key=AIzaSyB2d1OBcEjvh98TbfquvuxGWvIErOUIRKc"
        let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!, completionHandler: {(data,response,error) in
            print(data)
            guard let data = data else {
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel:Response = try jsonDecoder.decode(Response.self, from: data)
//                print(responseModel.results[0])
                
                self.delegate?.didDownload(response: responseModel)
            } catch {
                
            }
            
        })
        task.resume()
    }
}

protocol NetworkManagerDelegate {
    func didDownload(response: Response)
}
//let span2 = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
//let location2: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.732111, longitude: -122.398792)
//let region2 = MKCoordinateRegion(center: location2, span: span2)
//mapView.setRegion(region2, animated: true)
