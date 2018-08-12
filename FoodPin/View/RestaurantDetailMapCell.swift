//
//  RestaurantDetailMapCell.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 08/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailMapCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Add a annotation pin to the map
    func configure(location: String) {
        // location: restaurant address string
        
        // Get Location
        let geoCoder = CLGeocoder()
        print(location)
        
        geoCoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placeMarks = placemarks {
                // Get first place mark
                let placeMark = placeMarks[0]
                
                // Add Annotation
                let annotation = MKPointAnnotation()
                
                if let location = placeMark.location {
                    // Display the annotation
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // Set the zoom level
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        }
    }
}
