//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 08/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    var restaurant: RestaurantMO!
    
    // MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        if let restaurantImage = restaurant.image {
            backgroundImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        // Applying blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        // Slide animation
        // iOS provides a structure called CGAffineTransform for you to move, scale and rotate a view
        // Move all the buttons to far right as they appear out of the screen
//        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
//        // Make the button invisible
//        for rateButton in rateButtons {
//            // The transform property of each button is assigned with moveRightTransform. This will move the buttons off the screen to the right.
//            rateButton.transform = moveRightTransform
//            rateButton.alpha = 0
//        }
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        // concatenate one transform with another
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        // Make the button invisible and move off the screen
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
        
        // Adding animation to close buttton
        let moveUpTransform = CGAffineTransform.init(translationX: 0, y: -800)
        closeButton.transform = moveUpTransform
    }
    
    override func viewWillAppear(_ animated: Bool) {

        for index in 0...rateButtons.count - 1 {
            UIView.animate(withDuration: 0.4, delay: 0.1 + 0.05 * Double(index), options: [], animations: {
                self.rateButtons[index].alpha = 1.0
                self.rateButtons[index].transform = .identity
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: [], animations: {
            self.closeButton.transform = .identity
        }, completion: nil)
    }
    
    /*
     override func viewWillAppear(_ animated: Bool) {
     
     UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
     self.rateButtons[0].alpha = 1.0
     self.rateButtons[0].transform = .identity
     }, completion: nil)
     
     UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
     self.rateButtons[1].alpha = 1.0
     self.rateButtons[1].transform = .identity
     }, completion: nil)
     
     UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
     self.rateButtons[2].alpha = 1.0
     self.rateButtons[2].transform = .identity
     }, completion: nil)
     
     UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
     self.rateButtons[3].alpha = 1.0
     self.rateButtons[3].transform = .identity
     }, completion: nil)
     
     UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
     self.rateButtons[4].alpha = 1.0
     self.rateButtons[4].transform = .identity
     }, completion: nil)
     
     }
     */
}
