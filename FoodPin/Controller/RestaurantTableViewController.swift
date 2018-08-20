//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 30/06/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {

    // MARK:- Properties
    
    @IBOutlet weak var emptyRestaurantView: UIView!
    var restaurants:[RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    var searchController: UISearchController!
    var searchResults : [RestaurantMO] = []
    
    // MARK: - View Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // For iPAD
        tableView.cellLayoutMarginsFollowReadableWidth = true

        // For Large Title Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Make the navigation bar Transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // largeTitleTextAttributes: used to customize navigation bars large title text
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            // NSAttributedStringKey is renamed to NSAttributedString.Key
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
        }
        
        // Prepare empty View
        tableView.backgroundView = emptyRestaurantView
        tableView.backgroundView?.isHidden = true
        
        // Fetch Data from Core Data
        let fetchRequest: NSFetchRequest<RestaurantMO> = RestaurantMO.fetchRequest()
        let sortDesciptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDesciptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    restaurants = fetchedObjects
                }
            } catch {
                print("Error in fetching data from core data : \(error)")
            }
        }
        
        // Search View Controller
        // Adding a search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // Customizing Search Bar
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Search restaurants...", comment: "Search restaurants...")
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor(red: 231, green: 76, blue: 60)
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar on swipe
        navigationController?.hidesBarsOnSwipe = true
    }
    
    // MARK: - bring up the walkthrough view controller when a user first launches the app
    override func viewDidAppear(_ animated: Bool) {
        // Check if user has already viewed the walkthrough
        if UserDefaults.standard.bool(forKey: "hasViewedWalkThrough") {
            return
        }
        
        // Show walkthrough if user has not viewed it
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkThroughViewController {
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if restaurants.count > 0 {
            tableView.backgroundView?.isHidden = true
            tableView.separatorStyle = .singleLine
        } else {
            tableView.backgroundView?.isHidden = false
            tableView.separatorStyle = .none
        }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchController?.isActive)! {
            return self.searchResults.count
        }
        return self.restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        
        // Determine if we get the restaurant from search result
        let restaurant = (searchController?.isActive)! ? searchResults[indexPath.row] : restaurants[indexPath.row]
        
        // Configure the cell...
        cell.nameLabel.text = restaurant.name
        cell.locationType.text = restaurant.location
        cell.typeLocation.text = restaurant.type
        if let restaurantImage = restaurant.image {
            cell.thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if searchController.isActive {
            return false
        }
        return true
    }
    
    // MARK: - Swipe Left actions
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Delete", comment: "Delete")) { (action, sourceView, completionHandler) in
//            // Delete the row from data source
//            self.restaurants.remove(at: indexPath.row)
//
//            // Deletes a specific row
//            tableView.deleteRows(at: [indexPath], with: .fade)
            
            // Delete restaurant from Core Data
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                let context = appDelegate.persistentContainer.viewContext
                let restaurantToDelete = self.fetchResultController.object(at: indexPath)
                context.delete(restaurantToDelete)
                appDelegate.saveContext()
            }
            // Call completion handler to dismiss the action button
            completionHandler(true)
        }
        
        // Share Action
        let shareAction = UIContextualAction(style: .normal, title: NSLocalizedString("Share", comment: "Share")) { (action, sourceView, completionHandler) in
            let defaultText = "Just checking at " + self.restaurants[indexPath.row].name!
            let activityController : UIActivityViewController
            
            // Share image
            if let restaurantImage = self.restaurants[indexPath.row].image, let imageToShare = UIImage(data: restaurantImage as Data) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            // Setting the popover controller for iPAD
            if let popOverController = activityController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popOverController.sourceView = cell
                    popOverController.sourceRect = cell.bounds
                }
            }
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        
        // Customize the swipe action buttons
        deleteAction.backgroundColor = UIColor(red: 231, green: 76, blue: 60)
        deleteAction.image = UIImage(named: "delete")
        
        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(named: "share")
        
        let swipConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipConfiguration
    }
    
    // MARK: - Swip Right Action
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        // Check-in and UnCheck Action
        let checkInAction = UIContextualAction(style: .normal, title: NSLocalizedString("Check-in", comment: "Check-in")) { (action, sourceView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
            self.restaurants[indexPath.row].isVisited = (self.restaurants[indexPath.row].isVisited) ? false : true
            cell.accessoryType = self.restaurants[indexPath.row].isVisited ? .checkmark : .none
            completionHandler(true)
        }
        
        // Customize the swipe action buttons
        checkInAction.backgroundColor = UIColor(red: 34, green: 139, blue: 34)
        checkInAction.image = self.restaurants[indexPath.row].isVisited ? UIImage(named: "undo") : UIImage(named: "tick")
        
        let swipConfiguration: UISwipeActionsConfiguration
        swipConfiguration = UISwipeActionsConfiguration(actions: [checkInAction])
       
        return swipConfiguration
    }
    
    // MARK: - Prepare for Segue Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showRestaurantDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! RestaurantDetailViewController
                destinationController.restaurant = (searchController?.isActive)! ? searchResults[indexPath.row] : restaurants[indexPath.row]
            }
        }
    }
    
    // MARK: - unwind segue
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - NSFetchedResultControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                tableView.reloadRows(at: [updateIndexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - UISearchController
    func filterContent(for searchText: String) {
        searchResults = restaurants.filter({ (restaurant) -> Bool in
            if let name = restaurant.name, let location = restaurant.location {
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || location.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
}



// MARK: - Tableview Delegate
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Create an option menu by action sheet
//        let optionMenu = UIAlertController(title: nil, message: "What do you want to do ?", preferredStyle: .actionSheet)
//
//        // Setting the popover controller for iPAD
//        if let popOverController = optionMenu.popoverPresentationController {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                popOverController.sourceView = cell
//                popOverController.sourceRect = cell.bounds
//            }
//        }
//
//        // Add actions to menu
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        optionMenu.addAction(cancelAction)
//
//
//        // Adding call action handler
//        let callActionHandler = { (action: UIAlertAction!) -> Void in
//
//            let alertMessage = UIAlertController(title: "Service Unavailable", message: "Sorry, the feature is not available yet. Please try later.", preferredStyle: .alert)
//            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            self.present(alertMessage, animated: true, completion: nil)
//        }
//        let callAction = UIAlertAction(title: "Call" + "123-000-\(indexPath.row)", style: .default, handler: callActionHandler)
//        optionMenu.addAction(callAction)
//
//        let cell = tableView.cellForRow(at: indexPath)
//        if self.restaurantIsVisited[indexPath.row] == false {
//            // Check in action
//            let checkInAction = UIAlertAction(title: "Check in", style: .default) { (action: UIAlertAction) -> Void in
//                cell?.accessoryType = .checkmark
//                self.restaurantIsVisited[indexPath.row] = true
//            }
//            optionMenu.addAction(checkInAction)
//        } else {
//            // UnCheck action
//            let unCheckAction = UIAlertAction(title: "Undo Check", style: .default) { (action: UIAlertAction) -> Void in
//                cell?.accessoryType = .none
//                self.restaurantIsVisited[indexPath.row] = false
//            }
//            optionMenu.addAction(unCheckAction)
//        }
//
//        // Display Menu
//        present(optionMenu, animated: true, completion: nil)
//
//        // Deselect the row
//        tableView.deselectRow(at: indexPath, animated: false)
//    }

// MARK: - Swipe to delete
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            restaurantNames.remove(at: indexPath.row)
//            restaurantImages.remove(at: indexPath.row)
//            restaurantTypes.remove(at: indexPath.row)
//            restaurantLocations.remove(at: indexPath.row)
//            restaurantIsVisited.remove(at: indexPath.row)
//        }
//        // Deletes a specific row
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
