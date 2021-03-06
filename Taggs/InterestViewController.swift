//
//  InterestViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 22/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Spring
import Parse

class InterestViewController: UIViewController {
    
    // MARK: - Public API
    var interest: Interest!
    
    // MARK: - Private
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newPostButton: DesignableButton!

    
    fileprivate let tableHeaderHeight: CGFloat = 350.0
    fileprivate let tableHeaderCutAway: CGFloat = 50.0
    
    fileprivate var headerView: InterestHeaderView!
    fileprivate var headerMaskLayer: CAShapeLayer!
    
    fileprivate var posts = [Post]()
    
    
    fileprivate enum Storyboard {
        static let cellIDWithImage = "PostCellWithImage"
        static let cellIDWithOutImage = "PostCellWithoutImage"
        
        static let segueIDShowComments = "Show Comments"
        static let segueIDNewPostVC = "Show Post Composer"

    }
    
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 387
        tableView.rowHeight = UITableViewAutomaticDimension

        headerView = tableView.tableHeaderView as! InterestHeaderView
        headerView.delegate = self
        headerView.interest = interest
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        
        headerMaskLayer = CAShapeLayer()
        headerMaskLayer.fillColor = UIColor.black.cgColor
        headerView.layer.mask = headerMaskLayer
        
        updateHeaderView()
        
        configureButtonAppearance()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        fetchPosts()
        
        // CATCHING NOTIFICATION FROM NewPostViewController
        
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        
        center.addObserver(forName: NSNotification.Name(rawValue: "NewPostCreated"), object: nil, queue: queue, using: { (notification) in
            
            if let newPost = notification.userInfo?["newPostObject"] as? Post {
                if !self.postWasDisplayed(newPost) {
                    self.posts.insert(newPost, at: 0)
                    self.tableView.reloadData()
                }
            }
            
        })

        
        
    }
    
    func postWasDisplayed(_ newPost: Post) -> Bool {
        for post in posts {
            if post.objectId! == newPost.objectId! {
                return true
            }
        }
        return false
    }

    
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - HELPER METHODS

    func updateHeaderView() {
        let effectiveHeight = tableHeaderHeight - tableHeaderCutAway / 2
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: tableView.bounds.width, height: tableHeaderHeight)
        
        if tableView.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y + tableHeaderCutAway/2
        }
        
        headerView.frame = headerRect
        
        // cut away
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height - tableHeaderCutAway))
        headerMaskLayer?.path = path.cgPath
        
    }
    
    // MARK: __PARSE METHODS__
    
    func fetchPosts() {
        
        let postQuery = PFQuery(className: Post.parseClassName())
        
        postQuery.order(byDescending: "createdAt")
        
        postQuery.whereKey("interestId", equalTo: interest.objectId!)
        
        postQuery.includeKey("user")
        
        postQuery.cachePolicy = PFCachePolicy.networkElseCache
        
        postQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                if let postsObjects = objects as [PFObject]! {
                    self.posts.removeAll()
                    
                    for postObject in postsObjects {
                        let post = postObject as! Post
                        self.posts.append(post)
                    }
                    
                    self.tableView.reloadData()
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }

        }
        
        
        
        
    }
    
    fileprivate func configureButtonAppearance() {
        newPostButton.borderWidth = 1.0
        newPostButton.cornerRadius = 20.0
        newPostButton.borderColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1.0)
        
    }


    // MARK: - ACTIONS

    @IBAction func actionNewPostButtonTapped(_ sender: DesignableButton) {
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()

        self.performSegue(withIdentifier: Storyboard.segueIDNewPostVC, sender: nil)
        
    }
    
    
    
    // MARK: - NAVIGATION
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.segueIDShowComments {
            let commentsVC = segue.destination as! CommentsViewController
            commentsVC.post = sender as! Post
        } else if segue.identifier == Storyboard.segueIDNewPostVC {
            let postComposer = segue.destination as! NewPostViewController
            postComposer.interest = interest
        }
    }
    

}




// MARK: - UITableViewDataSource

extension InterestViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if post.postImageFile != nil {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIDWithImage, for: indexPath) as! PostTableViewCell
        
            cell.post = post
            cell.delegate = self
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIDWithOutImage, for: indexPath) as! PostTableViewCell

            cell.post = post
            cell.delegate = self
            return cell
        }

        
    }
}

// MARK: - UITableViewDelegate

extension InterestViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = self.posts[indexPath.row]
        
        self.performSegue(withIdentifier: Storyboard.segueIDShowComments, sender: post)
        
    }
}



// MARK: - UIScrollViewDelegate

extension InterestViewController : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateHeaderView()
        
        // CHALLENGE: - Add code to show/hide "Pull down to close"
        let offsetY = scrollView.contentOffset.y
        let adjustment: CGFloat = 130.0
        
        // for later use
        if (-offsetY) > (tableHeaderHeight+adjustment) {
            self.dismiss(animated: true, completion: nil)
        }
        
        if (-offsetY) > (tableHeaderHeight) {
            self.headerView.pullDownToCloseLabel.isHidden = false
        } else {
            self.headerView.pullDownToCloseLabel.isHidden = true
        }
    }
}

// MARK: - ===InterestHeaderViewDelegate===

extension InterestViewController : InterestHeaderViewDelegate {
    func closeButtonClicked() {
        self.dismiss(animated: true, completion: nil)
        
    }
}



// MARK: - ===PostTableViewCellDelegate===

extension InterestViewController : PostTableViewCellDelegate {
    func commentButtonClicked(post: Post) {
        
        self.performSegue(withIdentifier: Storyboard.segueIDShowComments, sender: post)
        
    }
}















