//
//  UINavigationControllerExtension.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 08/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    // Controls which VC to use to determine the status bar style
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
