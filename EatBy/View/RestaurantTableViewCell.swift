//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 30/06/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    // MARK: - Properties
    @IBOutlet weak var thumbnailImageView: UIImageView! {
        didSet {
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.bounds.width / 2
            thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var locationType: UILabel!  {
        didSet {
            locationType.numberOfLines = 0
        }
    }
    @IBOutlet weak var typeLocation: UILabel!  {
        didSet {
            typeLocation.numberOfLines = 0
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
