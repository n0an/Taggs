//
//  NewInterestViewController.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Photos
import Spring
import Parse

class NewInterestViewController: UIViewController {
    
    // MARK: - OUTLETS
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundColorView: UIView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var newInterestTitleTextField: DesignableTextField!
    @IBOutlet weak var newInterestDescriptionTextView: UITextView!
    @IBOutlet weak var createNewInterestButton: DesignableButton!
    @IBOutlet weak var selectFeaturedImageButton: DesignableButton!
    
    @IBOutlet var hideKeyboardInputAccessoryView: UIView!
    
    
    // MARK: - PROPERTIES
    
    fileprivate var featuredImage: UIImage!
    
    // MARK: - STATUS BAR CUSTOMIZATION

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newInterestTitleTextField.inputAccessoryView = hideKeyboardInputAccessoryView
        newInterestDescriptionTextView.inputAccessoryView = hideKeyboardInputAccessoryView
        
        // Do any additional setup after loading the view.
        newInterestTitleTextField.becomeFirstResponder()
        newInterestTitleTextField.delegate = self
        newInterestDescriptionTextView.delegate = self
        
        // handle text view
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewInterestViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NewInterestViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

     
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        
    }
    
    // MARK: - HELPER METHODS

    func presentImagePicker() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    // MARK: __PARSE METHODS__
    func createNewInterest() {
        
        let featuredImageFile = createFileFrom(image: self.featuredImage)
        
        
        let newInterest = Interest(title: newInterestTitleTextField.text!, interestDescription: newInterestDescriptionTextView.text!, imageFile: featuredImageFile!, numberOfMembers: 1, numberOfPosts: 0)
        
        newInterest.saveInBackground { (success, error) in
            if error == nil {
                // success
                // update the current user's interestIds
                
                let currentUser = User.current()!
                
                currentUser.joinInterest(interestId: newInterest.objectId!)
                
                // POSTING NOTIFICATION, IT WILL BE CATCHED BY HomeViewController, and run fetching and updating HomeVC CollectionView
                
                let center = NotificationCenter.default
                let notification = NSNotification(name: NSNotification.Name(rawValue: "NewInterestCreated"), object: nil, userInfo: ["newInterestObject" : newInterest])
                center.post(notification as Notification)
                
                
            } else {
                // fail
                print("\(error!.localizedDescription)")
            }
        }
        

        
    }
    
    
    
    // ===TOUSE===
    // SHRINK RESIZE IMAGE
    
    // MARK: - IMAGE HANDLER
    
    struct ImageSize {
        static let height: CGFloat = 480.0
    }
    
    func createFileFrom(image: UIImage) -> PFFile! {
        
        let ratio = image.size.width / image.size.height
        
        let resizedImage = resizeImage(originalImage: image, toWidth: ImageSize.height * ratio, andHeight: ImageSize.height)
        
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
        
        return PFFile(name: "image.jpg", data: imageData)
    }
    
    func resizeImage(originalImage: UIImage, toWidth width: CGFloat, andHeight height: CGFloat) -> UIImage {
        
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        
        originalImage.draw(in: newRectangle)
        
        let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return resizedImage
    }

    
    
    
    // MARK: - ACTIONS

    
    @IBAction func selectFeaturedImageButtonClicked(_ sender: DesignableButton) {
        
        let authorization = PHPhotoLibrary.authorizationStatus()
        
        
        if authorization == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    self.selectFeaturedImageButtonClicked(sender)
                }
            })
            return
        }
        
        if authorization == .authorized {
            presentImagePicker()
        }

    }
    
    
    @IBAction func dismiss(_ sender: UIButton) {
        hideKeyboard()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func createNewInterestButtonClicked(_ sender: DesignableButton) {
        if newInterestDescriptionTextView.text == "Describe your new interest..." || newInterestTitleTextField.text!.isEmpty {
            shakeTextField()
        } else if featuredImage == nil {
            shakePhotoButton()
        } else {
            
            createNewInterest()
            
            self.hideKeyboard()
            
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func hideKeyboard() {
        if newInterestDescriptionTextView.isFirstResponder {
            newInterestDescriptionTextView.resignFirstResponder()
        } else if newInterestTitleTextField.isFirstResponder {
            newInterestTitleTextField.resignFirstResponder()
        }
    }

    
    // MARK: - ANIMATIONS
    func shakeTextField() {
        newInterestTitleTextField.animation = "shake"
        newInterestTitleTextField.curve = "spring"
        newInterestTitleTextField.duration = 1.0
        newInterestTitleTextField.animate()
    }
    
    func shakePhotoButton() {
        selectFeaturedImageButton.animation = "shake"
        selectFeaturedImageButton.curve = "spring"
        selectFeaturedImageButton.duration = 1.0
        selectFeaturedImageButton.animate()
    }
    
    
    
    // MARK: - TEXT VIEW HANDLERS
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.size
        
        self.newInterestDescriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        self.newInterestDescriptionTextView.scrollIndicatorInsets = self.newInterestDescriptionTextView.contentInset
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.newInterestDescriptionTextView.contentInset = UIEdgeInsets.zero
        self.newInterestDescriptionTextView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
}

// MARK: - UITextFieldDelegate

extension NewInterestViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if newInterestDescriptionTextView.text == "Describe your new interest..." && !textField.text!.isEmpty {
            newInterestDescriptionTextView.becomeFirstResponder()
        } else if newInterestTitleTextField.text!.isEmpty {
            shakeTextField()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension NewInterestViewController : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.text = ""
        return true

    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.isEmpty {
            textView.text = "Describe your new interest..."
        }
        
        return true
    }
    
}


// MARK: - UIImagePickerControllerDelegate

extension NewInterestViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        self.backgroundImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        featuredImage = self.backgroundImageView.image
        self.backgroundColorView.alpha = 0.8
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}




