//
//  MapViewController.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 08/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    var restaurant : RestaurantMO!
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Conform to MKMapViewDelegate
        mapView.delegate = self
        
        // Convert address to coordinates and add the annotation to map
        let geoCoder = CLGeocoder()
        // Convert String address to coordinates
        geoCoder.geocodeAddressString(restaurant.location ?? "") { (placeMarks, error) in
            
            if error != nil  {
//                print(error.localizedDescription)
                return
            }
            
            if let placeMarks = placeMarks {
                // Get first placeMark
                let placeMark = placeMarks[0]
                
                // Add Annotation, add pin to the map
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placeMark.location {
                 
                    // assign coordinates to annotation
                    annotation.coordinate = location.coordinate
                    
                    // Display annotation
                    self.mapView.showAnnotations([annotation], animated: true)

                    // Selects the annotation marker to turn it into selected state
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
        // show some properties in the map
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
    }
    
    // MARK: - MKMapViewDelegate method for customizing annotation
    // Every time the map view needs to display annotation, this method is called
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // reuse the annotation
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.glyphText = "😋"
        annotationView?.markerTintColor = UIColor.orange
        
        return annotationView
    }
}
