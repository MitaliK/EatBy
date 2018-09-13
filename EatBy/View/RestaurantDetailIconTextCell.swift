//
//  RestaurantDetailIconTextCell.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 07/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit

class RestaurantDetailIconTextCell: UITableViewCell {

     // MARK: - Properties
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var shortTextLabel: UILabel! {
        didSet {
            shortTextLabel.numberOfLines = 0
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
