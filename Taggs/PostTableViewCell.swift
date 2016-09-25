//
//  PostTableViewCell.swift
//  Taggs
//
//  Created by Anton Novoselov on 23/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Spring

protocol PostTableViewCellDelegate {
    func commentButtonClicked(post: Post)
}

class PostTableViewCell: UITableViewCell {
    
    // MARK: - Public API
    var post: Post! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: PostTableViewCellDelegate!
    
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    @IBOutlet weak var commentButton: DesignableButton!
    
    // MARK: - Private
    
//    fileprivate var currentUserDidLike: Bool {
//        get {
//            if let ids = post.likedUserIds {
//                if ids.contains(User.current()!.objectId!) {
//                    return true
//                }
//            }
//            return false
//        }
//    }
    
    fileprivate func updateUI() {
        
        // --- GETTING DATA FROM PARSE ---
        
        let user = post.user as! User

        user.profileImageFile?.getDataInBackground { (data, error) in
            if error == nil {
                if let imageData = data {
                    self.userProfileImageView.image = UIImage(data: imageData)!
                }
            } else {
                print("\(error?.localizedDescription)")
            }
        }
        
        userNameLabel.text = post.user.username!
        
        createdAtLabel.text = Date.shortStringFromDate(date: post.createdAt!)
        
        post.postImageFile?.getDataInBackground { (data, error) in
            
            if error == nil {
                
                if let imageData = data {
                    self.postImageView.image = UIImage(data: imageData)!
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
            
        }
        
        postTextLabel?.text = post.postText
        
        // ---------------------------
        
        
        // rounded post image view, user profile image
        postImageView?.layer.cornerRadius = 5.0
        postImageView?.layer.masksToBounds = true
        
        self.layoutIfNeeded()

        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.size.width/2
        userProfileImageView.clipsToBounds = true
        
        likeButton.setTitle("⭐️ \(post.numberOfLikes) Likes", for: .normal)
        
        configureButtonAppearance()
    }
    
    fileprivate func configureButtonAppearance() {
        likeButton.borderWidth = 2.0
        likeButton.cornerRadius = 3.0
        likeButton.borderColor = UIColor.lightGray
        
        commentButton?.borderWidth = 2.0
        commentButton?.cornerRadius = 3.0
        commentButton?.borderColor = UIColor.lightGray
    
    }
    
    
    @IBAction func likeButtonClicked(_ sender: DesignableButton) {

        
        if currentUserLikes() {
            post.dislike()
        } else {
            post.like()
        }
        
        likeButton.setTitle("⭐️ \(post.numberOfLikes) Likes", for: .normal)
        
        changeLikeButtonColor()
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        
    }
    
    
    
    fileprivate func changeLikeButtonColor() {
        
        if currentUserLikes() {
            likeButton.borderColor = UIColor.red
            likeButton.tintColor = UIColor.red
        } else {
            likeButton.borderColor = UIColor.lightGray
            likeButton.tintColor = UIColor.lightGray
        }
        
    }
    
    func currentUserLikes() -> Bool {
        
        if let ids = post.likedUserIds {
            if ids.contains(User.current()!.objectId!) {
                return true
            }
        }
        return false
        
    }
    
    @IBAction func commentButtonClicked(_ sender: DesignableButton) {
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        delegate?.commentButtonClicked(post: post)
    }
    
}
