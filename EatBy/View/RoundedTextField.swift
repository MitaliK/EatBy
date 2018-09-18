//
//  RoundedTextField.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 13/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit

class RoundedTextField: UITextField {
    
    // creates padding for text in text field on left and right sides
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    // MARK: - text indentation: Drawing rectange for text field
    
    // returns rectange for text field's text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    // returns rectange for text field's placeholders text
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.inset(by: padding)
    }
    
    // returns rectange for editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.inset(by: padding)
    }
    
    // MARK: - Making round corners
    // Called everytime when text field is laid out
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}
