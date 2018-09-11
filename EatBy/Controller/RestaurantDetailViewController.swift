//
//  RestaurantDetailViewController.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 04/07/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: RestaurantDetailHeaderView!
    
    var restaurant: RestaurantMO!
    
    // Change the status bar style
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
     // MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Large Title Navigation Bar
        navigationItem.largeTitleDisplayMode = .never
        
        // Configure Header View
        headerView.nameLabel.text = restaurant.name
        headerView.typeLabel.text = restaurant.type
        if let restaurantImage = restaurant.image{
            headerView.headerImagerView.image = UIImage(data: restaurantImage as Data)
        }
        headerView.heartImageView.isHidden = (restaurant.isVisited) ? false : true
        if let rating = restaurant.rating {
            headerView.ratingImageView.image = UIImage(named: rating)
        }
        
        // Set the table data source and delegate
        tableView.delegate = self
        tableView.dataSource = self
        
        // remove separator
        tableView.separatorStyle = .none
        
        // Make the navigation bar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .white
        
        // iOS automatically adjusts the content offset of the table view such that the content area will not be blocked by the navigation bar
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Tableview Data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = restaurant.phone
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = restaurant.location
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurant.summary
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailSeparatorCell.self), for: indexPath) as! RestaurantDetailSeparatorCell
            cell.titleLable.text = "HOW TO GET HERE:"
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailMapCell.self), for: indexPath) as! RestaurantDetailMapCell
            if let restaurantLocation = restaurant.location {
                cell.configure(location: restaurantLocation)
            }
            return cell
        default:
            fatalError("Failed to instantiate tableview cell for detail controller.")
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destination = segue.destination as! MapViewController
            destination.restaurant = restaurant
        } else if segue.identifier == "showReview" {
            let destination = segue.destination as! ReviewViewController
            destination.restaurant = restaurant
        }
    }
    
    // MARK: - Unwind segue
    @IBAction func close (segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
       
        dismiss(animated: true, completion: {
            if let rating = segue.identifier {
                self.restaurant.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)

                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    appDelegate.saveContext()
                }
                
                // Adding animation to review image
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }, completion: nil)
            }
        })
    }
}
