//
//  NewPostViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 23/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Photos

class NewPostViewController: UIViewController {
    
    // MARK: - PUBLIC API
    
    var interest: Interest!
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var currentUserProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postContentTextView: UITextView!
    @IBOutlet weak var postImageView: UIImageView!
    
    fileprivate var postImage: UIImage!
    
    // MARK: - BAR CUSTOMIZATION
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.view.layoutIfNeeded()
        
        postContentTextView.becomeFirstResponder()
        postContentTextView.text = ""
        
        currentUserProfileImageView.layer.cornerRadius = currentUserProfileImageView.bounds.width/2
        currentUserProfileImageView.layer.masksToBounds = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(NewPostViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
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
    
    func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: __PARSE METHODS__
    
    func uploadNewPost() {
        
        let currentUser = User.current()!
        
        let newPost = Post(user: currentUser, postImage: postImage, postText: postContentTextView.text, numberOfLikes: 0, interestId: interest.objectId!)
        
        newPost.saveInBackground { (success, error) in
            if error == nil {
                self.interest.incrementNumberOfPosts()
                
                let center = NotificationCenter.default
                let notification = NSNotification(name: NSNotification.Name(rawValue: "NewPostCreated"), object: nil, userInfo: ["newPostObject" : newPost])
                center.post(notification as Notification)
                
                
            } else {
                print("\(error?.localizedDescription)")
            }
            self.dismiss(animated: true, completion: nil)

        }
        
    }
    
    
    // MARK: - ACTIONS
    
    @IBAction func pickFeaturedImageClicked(_ sender: UITapGestureRecognizer) {
        
        print("SHOW IMAGE PICKER")
        
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        if authorization == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    self.pickFeaturedImageClicked(sender)
                }
            })
            return
        }
        
        if authorization == .authorized {
            presentImagePicker()
        }
        
        
    }
    
    @IBAction func dismiss() {
        
        postContentTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post() {
        
        uploadNewPost()
        
        postContentTextView.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK: - TEXT VIEW HANDLERS
    
    func keyboardWillHide(notification: NSNotification) {
        print("keyboardWillHide")
        
        self.postContentTextView.contentInset = UIEdgeInsets.zero
        self.postContentTextView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    func keyboardWillShow(notification: NSNotification) {
        print("keyboardWillShow")
        
        let userInfo = notification.userInfo ?? [:]
        
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        
        self.postContentTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.postContentTextView.scrollIndicatorInsets = self.postContentTextView.contentInset

    }
    
    
}


// MARK: - UIImagePickerControllerDelegate

extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.postImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.postImageView.image = self.postImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
















