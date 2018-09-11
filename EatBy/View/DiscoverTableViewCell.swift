//
//  DiscoverTableViewCell.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 19/08/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            locationLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var featureImageView: UIImageView! {
        didSet {
            featureImageView.contentMode = .scaleAspectFill
            featureImageView.clipsToBounds = true
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
