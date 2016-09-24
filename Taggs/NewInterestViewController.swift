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
            // create a new interest
            // ..
            
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




