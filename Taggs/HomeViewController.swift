//
//  HomeViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 22/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var currentUserProfileImageButton: UIButton!
    @IBOutlet weak var currentUserFullNameButton: UIButton!
    
    // MARK: - PROPERTIES
    fileprivate var interests = [Interest]()
    fileprivate var slideRightTransitionAnimator = SlideRightTransitionAnimator()
    fileprivate var popTransitionAnimator = PopTransitionAnimator()
    fileprivate var slideRightThenPopTransitionAnimator = SlideRightThenPopTransitionAnimator()
    
    fileprivate struct Storyboard {
        static let cellID = "Interest Cell"
        static let segueShowInterest = "Show Interest"
        static let segueIDNewInterest = "CreateNewInterest"
        static let segueIDShowDiscovery = "Show Discover"
    }
    
    // MARK: - STATUS BAR CUSTOMIZATION
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.size.height == 480.0 {
            let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            flowLayout.itemSize = CGSize(width: 250.0, height: 300.0)
        }
        
        configureUserProfile()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.current() == nil {
            
            presentLoginViewController()
            
        } else {
            
            fetchInterests()
            
            // CATCHING NOTIFICATION FROM NewInterestViewController
            
            let center = NotificationCenter.default
            let queue = OperationQueue.main
            
            
            center.addObserver(forName: NSNotification.Name(rawValue: "NewInterestCreated"), object: nil, queue: queue, using: { (notification) in
                
                if let newInterest = notification.userInfo?["newInterestObject"] as? Interest {
                    if !self.interestWasDisplayed(newInterest) {
                        self.interests.insert(newInterest, at: 0)
                        self.collectionView.reloadData()
                    }
                }
                
            })
            
            
            
        }
        
    }
    
    func interestWasDisplayed(_ newInterest: Interest) -> Bool {
        for interest in interests {
            if interest.objectId! == newInterest.objectId! {
                return true
            }
        }
        return false
    }
    
    
    // MARK: - HELPER METHODS

    func configureUserProfile() {
        
        self.view.layoutIfNeeded()
        // configure image button
        currentUserProfileImageButton.contentMode = .scaleAspectFill
        currentUserProfileImageButton.layer.cornerRadius = currentUserProfileImageButton.bounds.width / 2
        currentUserProfileImageButton.layer.masksToBounds = true
    }
    
    
    // MARK: __PARSE METHODS__
    
    func fetchInterests() {
        let currentUser = User.current()!
        
        let interestIds = currentUser.interestIds
        
        if interestIds.count > 0 {
            
            let interestQuery = PFQuery(className: Interest.parseClassName())
            
            interestQuery.order(byDescending: "updatedAt")
            
            interestQuery.whereKey("objectId", containedIn: interestIds)
            
            
            interestQuery.findObjectsInBackground(block: { (objects, error) in
                
                if error == nil {
                    if let interestObjects = objects as [PFObject]! {
                        self.interests.removeAll()
                        
                        for interestObject in interestObjects {
                            let interest = interestObject as! Interest
                            self.interests.append(interest)
                        }
                        
                        self.collectionView.reloadData()
                    }
                } else {
                    print("\(error?.localizedDescription)")
                }
                
            })
        }
        
    }
    
    
    @IBAction func actionUserProfileButtonClicked() {
        
        PFUser.logOut()
        presentLoginViewController()
        
    }
    
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.segueShowInterest {
            let cell = sender as! InterestCollectionViewCell
            let interest = cell.interest
            
            let navigationViewController = segue.destination as! UINavigationController
            
            navigationViewController.transitioningDelegate = popTransitionAnimator
            
            let interestViewController = navigationViewController.topViewController as! InterestViewController
            
            interestViewController.interest = interest
            
        } else if segue.identifier == Storyboard.segueIDNewInterest {
            let newInterestVC = segue.destination as! NewInterestViewController
            
            newInterestVC.transitioningDelegate = slideRightTransitionAnimator
            
        } else if segue.identifier == Storyboard.segueIDShowDiscovery {
            
            let discoveryVC = segue.destination as! DiscoverViewController
            
            discoveryVC.transitioningDelegate = slideRightThenPopTransitionAnimator
            
        }

    }
    
    
}



extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.cellID, for: indexPath) as! InterestCollectionViewCell
        
        cell.interest = self.interests[indexPath.row]
        
        return cell
        
        
    }
    
    
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: -scrollView.contentInset.top)
        targetContentOffset.pointee = offset
        
    }
    
}



// MARK: - PARSE LOGIN / SIGNUP

extension HomeViewController: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    func presentLoginViewController() {
        
        let loginController = PFLogInViewController()
        let signupController = PFSignUpViewController()
        
        signupController.delegate = self
        loginController.delegate = self
        
        loginController.fields = [PFLogInFields.usernameAndPassword, PFLogInFields.logInButton, PFLogInFields.signUpButton]
        
        loginController.signUpController = signupController
        
        present(loginController, animated: true, completion: nil)
        
        
    }
    
    
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        logInController.dismiss(animated: true, completion: nil)
    }
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        signUpController.dismiss(animated: true, completion: nil)
    }
    
    // TODO: - add Parse installation from NagSnapChat loginsignupvc
}
































