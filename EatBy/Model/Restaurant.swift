//
//  Restaurant.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 04/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import Foundation

class Restaurant {
    
    // MARK: - Stored Properties
    var name: String
    var type: String
    var location: String
    var phone: String
    var description: String
    var imageName: String
    var isVisited: Bool
    var rating: String
    
    init(name: String, type: String, location: String, phone: String, description: String, imageName: String, isVisited: Bool, rating: String = "") {
        self.name = name
        self.type = type
        self.location = location
        self.phone = phone
        self.description = description
        self.imageName = imageName
        self.isVisited = isVisited
        self.rating = rating
    }
    
    convenience init() {
        self.init(name: "", type: "", location: "", phone: "", description: "", imageName: "", isVisited: false)
    }
}
