//
//  NewCommentViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class NewCommentViewController: UIViewController {
    
    // MARK: - PUBLIC API
    
    var post: Post!
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var currentUserProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    // MARK: - BAR CUSTOMIZATION
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentTextView.becomeFirstResponder()
        commentTextView.text = ""

        self.view.layoutIfNeeded()
        
        currentUserProfileImageView.layer.cornerRadius = currentUserProfileImageView.bounds.width/2
        currentUserProfileImageView.layer.masksToBounds = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewCommentViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCommentViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentUser = User.current()!
        self.usernameLabel.text = currentUser.username!
        
        if let imageFile = currentUser.profileImageFile {
            imageFile.getDataInBackground(block: { (data, error) in
                if error == nil {
                    
                    if let imageData = data {
                        if let image = UIImage(data: imageData) {
                            self.currentUserProfileImageView.image! = image
                        }
                    }
                    
                } else {
                    
                }
            })
        }

        
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - HELPER METHODS
    
    // MARK: __PARSE METHODS__
    
    func uploadNewComment() {
        
        let currentUser = User.current()!
        
        let newComment = Comment(postId: self.post.objectId!, user: currentUser, commentText: commentTextView.text, numberOfLikes: 0)
        
        newComment.saveInBackground { (success, error) in
            if error == nil {
                
                // comment has been added
                
            } else {
                print("\(error?.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }

    
    // MARK: - ACTIONS
    
    @IBAction func dismissComposer() {
        
        commentTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postDidTap() {
        
        uploadNewComment()
        
        commentTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - TEXT VIEW HANDLERS
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        
        self.commentTextView.contentInset = UIEdgeInsets.zero
        self.commentTextView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        
        let userInfo = notification.userInfo ?? [:]
        
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        
        self.commentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.commentTextView.scrollIndicatorInsets = self.commentTextView.contentInset
        
    }
    
    
}





