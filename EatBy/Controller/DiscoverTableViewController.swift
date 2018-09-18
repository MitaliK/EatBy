//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Mitali Kulkarni on 14/08/18.
//  Copyright © 2018 Mitali Kulkarni. All rights reserved.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {

    // MARK: - Properties
    var restaurants: [CKRecord] = []
    var spinner = UIActivityIndicatorView()
    // Cache
    // This imageCache is designed for caching NSURL objects using CKRecordID as a key
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // For iPAD
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        // For Large Title Bar
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Configure navigation bar appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // largeTitleTextAttributes: used to customize navigation bars large title text
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            // NSAttributedStringKey is renamed to NSAttributedString.Key
            navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont]
        }
        
        // Adding spinner
        spinner.style = .gray
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // Define layout constraints on the spinner view
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0), spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        
        // Activate the spinner
        spinner.startAnimating()
        
        // When the Discover tab is loaded, the app will start to fetch the records via CloudKit.
        fetchRecordsFromCloud()
        
        // pull to refresh
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: UIControl.Event.valueChanged)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DiscoverTableViewCell.self), for: indexPath) as! DiscoverTableViewCell
        
        // Configure the cell...
        let restaurant = restaurants[indexPath.row]
        cell.nameLabel.text = restaurant.object(forKey: "name") as? String
        cell.typeLabel.text = restaurant.object(forKey: "type") as? String
        cell.locationLabel.text = restaurant.object(forKey: "location") as? String
        cell.phoneLabel.text = restaurant.object(forKey: "phone") as? String
        cell.descriptionLabel.text = restaurant.object(forKey: "description") as? String
        
        // Set the default image
        cell.featureImageView.image = UIImage(named: "photo")
        
        // Check if the image is stored in cache
        if let imageFileURL = imageCache.object(forKey: restaurant.recordID) {
            // Fetch image from cache
            if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                cell.featureImageView.image = UIImage(data: imageData)
            }
            
        } else {
            // Fetch Image from Cloud in background
            let publicDatabase = CKContainer.default().publicCloudDatabase
            // To fetch the image of a specific restaurant record, we create a CKFetchRecordsOperation object with the ID of that particular restaurant record.
            let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
            fetchRecordsImageOperation.desiredKeys = ["image"]
            fetchRecordsImageOperation.queuePriority = .veryHigh
            
            // The operation object executes this block once for each record ID in the recordIDs property. Each time the block is executed, it is executed serially with respect to the other progress blocks of the operation.
            fetchRecordsImageOperation.perRecordCompletionBlock = { (record, recordID, error) -> Void in
                if error != nil  {
                    return
                }
                
                if let restaurantRecord = record,
                    let image = restaurantRecord.object(forKey: "image"),
                    let imageAsset = image as? CKAsset {
                    
                    if let imageData = try? Data.init(contentsOf: imageAsset.fileURL) {
                        
                        // Replace the placeholder image with the restaurant image
                        DispatchQueue.main.async {
                            cell.featureImageView.image = UIImage(data: imageData)
                            cell.setNeedsLayout()
                        }
                        
                        // Add the image URL to cache
                        self.imageCache.setObject(imageAsset.fileURL as NSURL, forKey: restaurant.recordID)
                    }
                }
            }
            
            publicDatabase.add(fetchRecordsImageOperation)
        }
        
        return cell
    }

    // MARK: - Helper function
    @objc func fetchRecordsFromCloud() {
        
        // Remove existing records before refreshing
        restaurants.removeAll()
        tableView.reloadData()
        
        // Fetching data using Convenience API
        let cloudContainer = CKContainer.default()
        // Get public database
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        
        // create query
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        // Create query operation with the query
        // Operational API
        let queryOperation = CKQueryOperation(query: query)
        // Fields to fetch
        queryOperation.desiredKeys = ["name", "type", "location", "phone", "description" ]
        // Execution priority of the operation
        queryOperation.queuePriority = .veryHigh
        // Max number of records at one time
        queryOperation.resultsLimit = 50
        queryOperation.recordFetchedBlock = {(record) -> Void in
            // Executed every time the record is returned
            self.restaurants.append(record)
        }
        
        // Executes after all the records are fetched
        // Cursor: Indicates if there are more results remaining to fetch
        queryOperation.queryCompletionBlock = {(cursor, error) -> Void in
            if error != nil {
                return
            }
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
                
                // To remove the refreshController
                if let refreshControl = self.refreshControl {
                    if refreshControl.isRefreshing {
                        refreshControl.endRefreshing()
                    }
                }
            }
        }
        
        // Execute query
        publicDatabase.add(queryOperation)
    }
}
