//
//  CommentTableViewCell.swift
//  Taggs
//
//  Created by nag on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Spring

class CommentTableViewCell: UITableViewCell
{
    // MARK: - Public API
    var comment: Comment! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    
    // MARK: - Private
    
    fileprivate func updateUI() {
        
        // --- GETTING DATA FROM PARSE ---
        
        let user = comment.user as! User
        
        userNameLabel.text = user.username!
        
        commentTextLabel.text = comment.commentText
        
        // ---------------------------
        
        likeButton.setTitle("⭐️ \(comment.numberOfLikes) Likes", for: .normal)
        
        changeLikeButtonColor()
        
        
    }
   
    @IBAction func likeButtonClicked(sender: DesignableButton) {
        
        if currentUserLikes() {
            comment.dislike()
        } else {
            comment.like()
        }
        
        likeButton.setTitle("⭐️ \(comment.numberOfLikes) Likes", for: .normal)
        
        changeLikeButtonColor()
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
    }
    
    
    
    private func changeLikeButtonColor() {
        if currentUserLikes() {
            likeButton.borderColor = UIColor.red
            likeButton.tintColor = UIColor.red
        } else {
            likeButton.borderColor = UIColor.lightGray
            likeButton.tintColor = UIColor.lightGray
        }
        
    }
    
    func currentUserLikes() -> Bool {
        
        if let ids = comment.likedUserIds {
            if ids.contains(User.current()!.objectId!) {
                return true
            }
        }
        
        return false
        
    }
}







