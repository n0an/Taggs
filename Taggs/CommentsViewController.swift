//
//  CommentsViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    
    // MARK: - Public API
    var post: Post!
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newCommentButton: UIButton!
    
    // MARK: - PRIVATE PROPERTIES
    
    fileprivate var comments = [Comment]()
    
    fileprivate enum Storyboard {
        static let cellIDWithImage = "PostCellWithImage"
        static let cellIDWithoutImage = "PostCellWithoutImage"
        static let cellIDComment = "Comment Cell"
        static let segueIDShowCommentVC = "Show Comment Composer"
    }


    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchComments()

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
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    
    fileprivate func fetchComments() {
        
        self.comments = Comment.allComments()
        
        tableView.reloadData()
        
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
            if post.postImage == nil {
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






















