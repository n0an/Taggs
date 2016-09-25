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
    
    private var currentUserDidLike: Bool = false
    
    private func updateUI() {
        
//        userNameLabel.text = comment.user.fullName
        
        commentTextLabel.text = comment.commentText
        
        likeButton.setTitle("⭐️ \(comment.numberOfLikes) Likes", for: .normal)
        
//        configureButtonAppearance()
    }
    
    private func configureButtonAppearance() {
        likeButton.cornerRadius = 3.0
        likeButton.borderWidth = 2.0
        likeButton.borderColor = UIColor.lightGray
    }
    
    @IBAction func likeButtonClicked(sender: DesignableButton)
    {
//        comment.userDidLike = !comment.userDidLike
//        if comment.userDidLike {
//            comment.numberOfLikes += 1
//        } else {
//            comment.numberOfLikes -= 1
//        }
//        
//        likeButton.setTitle("⭐️ \(comment.numberOfLikes) Likes", for: .normal)
//        
//        currentUserDidLike = comment.userDidLike
        
        changeLikeButtonColor()
        
        // animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
    }
    
    private func changeLikeButtonColor()
    {
        if currentUserDidLike {
            likeButton.borderColor = UIColor.red
            likeButton.tintColor = UIColor.red
        } else {
            likeButton.borderColor = UIColor.lightGray
            likeButton.tintColor = UIColor.lightGray
        }
        
    }
}
