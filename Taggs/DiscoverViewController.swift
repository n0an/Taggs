//
//  DiscoverViewController.swift
//  Taggs
//
//  Created by nag on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

class DiscoverViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var searchBarInputAccessoryView: UIView!
    
    // MARK: - PRIVATE
    
    fileprivate var searchText: String! {
        didSet {
            searchInterestsFor(key: searchText)
        }
    }
    
    fileprivate enum Storyboard {
        static let segueIdShowInterest = "Show Discover Interest"
        static let cellIdInterest = "Interest Cell"
    }
    
    fileprivate var interests = [Interest]()
    fileprivate var popTransitionAnimator = PopTransitionAnimator()
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.inputAccessoryView = searchBarInputAccessoryView
        
        // Make the row height dynamic
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // backgroundColor, separator, don't allow selection
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor.clear
        tableView.allowsSelection = false
        
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        suggestInterests()
    }
    
    // MARK: - HELPER METHODS
    
    func searchInterestsFor(key: String) {
        
        let pred = NSPredicate(format: "title BEGINSWITH %@ OR interestDescription BEGINSWITH %@", argumentArray: [key, key])

        let query = PFQuery(className: Interest.parseClassName(), predicate: pred)
        
        query.order(byDescending: "updatedAt")
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                if let objects = objects as [PFObject]! {
                    self.interests.removeAll()
                    
                    for interesetObject in objects {
                        let interest = interesetObject as! Interest
                        
                        self.interests.append(interest)
                    }
                    self.tableView.reloadData()
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
        interests = [Interest]()
        tableView.reloadData()
    }
    
    func suggestInterests() {
        
        let query = PFQuery(className: Interest.parseClassName())
        
        query.order(byDescending: "updatedAt")
        
        query.limit = 20
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                if let objects = objects as [PFObject]! {
                    self.interests.removeAll()
                    
                    for interesetObject in objects {
                        let interest = interesetObject as! Interest
                        
                        self.interests.append(interest)
                    }
                    self.tableView.reloadData()
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
        
    }
    
    // MARK: - ACTIONS
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func refreshButtonClicked(_ sender: UIButton) {
        
    }
    
    
    @IBAction func hideKeyboardButtonClicked(_ sender: UIButton) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.segueIdShowInterest {
            let navVC = segue.destination as! UINavigationController
            let interestVC = navVC.topViewController as! InterestViewController
            interestVC.interest = sender as! Interest
            navVC.transitioningDelegate = popTransitionAnimator
        }
    }
    
    
    
}

// MARK: - UISearchBarDelegate

extension DiscoverViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text! != "" {
            searchText = searchBar.text!.lowercased()
        }
        
        searchBar.resignFirstResponder()
    }
}

// MARK: - UITableViewDataSource

extension DiscoverViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIdInterest, for: indexPath) as! DiscoverTableViewCell
        
        cell.interest = interests[indexPath.row]
        cell.delegate = self
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
}

// MARK: - ===DiscoverTableViewCellDelegate===
extension DiscoverViewController : DiscoverTableViewCellDelegate {
    
    func joinButtonClicked(interest: Interest!) {
        
        performSegue(withIdentifier: Storyboard.segueIdShowInterest, sender: interest)
        
        
    }
}



