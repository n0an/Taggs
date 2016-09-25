//
//  CommentsViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Spring
import Parse

class CommentsViewController: UIViewController {
    
    // MARK: - Public API
    var post: Post!
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newCommentButton: DesignableButton!
    
    // MARK: - PRIVATE PROPERTIES
    
    fileprivate var comments = [Comment]()
    
    fileprivate enum Storyboard {
        static let cellIDWithImage = "PostCellWithImage"
        static let cellIDWithoutImage = "PostCellWithoutImage"
        static let cellIDComment = "Comment Cell"
        static let segueIDShowCommentComposer = "Show Comment Composer"
    }
    

    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // configure the navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: "EE8222")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        title = "Comments"
        
        // configure the table view
        // make the table View to have dynamic height
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        tableView.allowsSelection = false
        
        configureButtonAppearance()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        fetchComments()
        
        // CATCHING NOTIFICATION FROM NewInterestViewController
        
        let center = NotificationCenter.default
        let queue = OperationQueue.main
        
        center.addObserver(forName: NSNotification.Name(rawValue: "NewCommentCreated"), object: nil, queue: queue, using: { (notification) in
            
            if let newComment = notification.userInfo?["newCommentObject"] as? Comment {
                if !self.commentWasDisplayed(newComment) {
                    self.comments.insert(newComment, at: 0)
                    self.tableView.reloadData()
                }
            }
            
        })

        

    }
    
    
    func commentWasDisplayed(_ newComment: Comment) -> Bool {
        for comment in comments {
            if comment.objectId! == newComment.objectId! {
                return true
            }
        }
        return false
    }

    // MARK: - HELPER METHODS

    // MARK: __PARSE METHODS__

    fileprivate func fetchComments() {
        
        
        let commentQuery = PFQuery(className: Comment.parseClassName())
        
        
        commentQuery.order(byDescending: "createdAt")

        
        commentQuery.whereKey("postId", equalTo: post.objectId!)
        
        commentQuery.includeKey("user")
        
        commentQuery.cachePolicy = PFCachePolicy.networkElseCache
        
        commentQuery.findObjectsInBackground { (objects, error) in
            
            if error == nil {
                
                if let commentObjects = objects as [PFObject]! {
                    self.comments.removeAll()
                    
                    for commentObject in commentObjects {
                        let comment = commentObject as! Comment
                        self.comments.append(comment)
                    }
                    
                    self.tableView.reloadData()
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
            
        }
        
        
    }
    
    fileprivate func configureButtonAppearance() {
        newCommentButton.borderWidth = 1.0
        newCommentButton.cornerRadius = 20.0
        newCommentButton.borderColor = UIColor(red: 85.0/255, green: 172.0/255, blue: 238.0/255, alpha: 1.0)
        
    }

    
    @IBAction func actionNewCommentButtonTapped(_ sender: DesignableButton) {
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        self.performSegue(withIdentifier: Storyboard.segueIDShowCommentComposer, sender: nil)
    }
    
    
    // MARK: - NAVIGATION

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.segueIDShowCommentComposer {
            let commentComposer = segue.destination as! NewCommentViewController
            commentComposer.post = self.post
        }
    }
    

}



extension CommentsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            if post.postImageFile == nil {
                // main post cell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIDWithoutImage, for: indexPath) as! PostTableViewCell
                
                cell.post = post
                
                return cell
                
            } else {
                // main post cell
                
                let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIDWithImage, for: indexPath) as! PostTableViewCell

                cell.post = post
                return cell
            }
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.cellIDComment, for: indexPath) as! CommentTableViewCell
            
            cell.comment = self.comments[indexPath.row - 1]
            return cell
        }

        
    }
    
}






















