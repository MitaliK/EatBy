//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 07/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit

class RestaurantDetailHeaderView: UIView {

     // MARK: - Properties
    @IBOutlet weak var headerImagerView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            // To automatically determine the number of lines to fit its content
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var typeLabel: UILabel! {
        didSet {
            typeLabel.layer.cornerRadius = 5.0
            // Core Animation creates an implicit clipping mask that matches the bounds of the layer and includes any corner radius effects. 
            typeLabel.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var heartImageView: UIImageView! {
        didSet {
            heartImageView.image = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate)
            heartImageView.tintColor = .white
        }
    }
    
    @IBOutlet weak var ratingImageView: UIImageView!
}
