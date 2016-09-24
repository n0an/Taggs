//
//  DiscoverViewController.swift
//  Taggs
//
//  Created by nag on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var searchBarInputAccessoryView: UIView!
    
    fileprivate var searchText: String! {
        didSet {
            searchInterestsFor(key: searchText)
        }
    }
    
    fileprivate var interests = [Interest]()
    fileprivate var popTransitionAnimator = PopTransitionAnimator()
    
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
        
        suggestInterests()
    }
    
    func searchInterestsFor(key: String) {
        interests = Interest.createInterests()
        tableView.reloadData()
    }
    
    func suggestInterests() {
        interests = Interest.createInterests()
        tableView.reloadData()
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIButton) {
        //
    }
    
    @IBAction func hideKeyboardButtonClicked(_ sender: UIButton) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Discover Interest" {
            let navVC = segue.destination as! UINavigationController
            let interestVC = navVC.topViewController as! InterestViewController
            interestVC.interest = sender as! Interest
            navVC.transitioningDelegate = popTransitionAnimator
        }
    }
    
    
    
}

extension DiscoverViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text! != "" {
            searchText = searchBar.text!.lowercased()
        }
        
        searchBar.resignFirstResponder()
    }
}

extension DiscoverViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interests.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Interest Cell", for: indexPath) as! DiscoverTableViewCell
        
        cell.interest = interests[indexPath.row]
        cell.delegate = self
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    
}

extension DiscoverViewController : DiscoverTableViewCellDelegate {
    
    func joinButtonClicked(interest: Interest!) {
        
        performSegue(withIdentifier: "Show Discover Interest", sender: interest)
        
        
    }
}



