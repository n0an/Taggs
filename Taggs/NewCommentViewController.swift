//
//  NewCommentViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class NewCommentViewController: UIViewController {
    
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

        
        currentUserProfileImageView.layer.cornerRadius = currentUserProfileImageView.bounds.width/2
        currentUserProfileImageView.layer.masksToBounds = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewCommentViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewCommentViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        self.view.layoutIfNeeded()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - HELPER METHODS
    

    
    // MARK: - ACTIONS
    
    
    // TODO: - create a new post and send it to parse
    @IBAction func dismissComposer() {
        
        commentTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postDidTap() {
        
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





