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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationType: UILabel!
    @IBOutlet weak var typeLocation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
