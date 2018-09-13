//
//  UIColorExtension.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 08/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(red) / 255.0
        let greenValue = CGFloat(green) / 255.0
        let blueValue = CGFloat(blue) / 255.0
        
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}
