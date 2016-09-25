//
//  InterestHeaderView.swift
//  Taggs
//
//  Created by Anton Novoselov on 22/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

protocol InterestHeaderViewDelegate {
    func closeButtonClicked()
}


class InterestHeaderView: UIView {
    
    // MARK: - Public API

    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    var delegate: InterestHeaderViewDelegate!
    
    fileprivate func updateUI() {
        
        interest.featuredImageFile.getDataInBackground { (imageData, error) in
            
            if error == nil {
                
                if let featuredImageData = imageData {
                    self.backgroundImageView.image = UIImage(data: featuredImageData)!
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
            
        }

        
        
        interestTitleLabel?.text! = interest.title
        numberOfMembersLabel.text! = "\(interest.numberOfMembers) members"
        numberOfPostsLabel.text! = "\(interest.numberOfPosts) posts"
        pullDownToCloseLabel.text! = "Pull down to close"
        pullDownToCloseLabel.isHidden = true
    }
    
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var numberOfMembersLabel: UILabel!
    @IBOutlet weak var numberOfPostsLabel: UILabel!
    @IBOutlet weak var pullDownToCloseLabel: UILabel!
    @IBOutlet weak var closeButtonBackgroundView: UIView!

    
    override func layoutSubviews() {
        super.layoutSubviews()
        closeButtonBackgroundView.layer.cornerRadius = closeButtonBackgroundView.bounds.width / 2
        closeButtonBackgroundView.layer.masksToBounds = true
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton)
    {
        print("close button tapped gets called")
        // delegate right now is InterestViewController
        delegate.closeButtonClicked()
    }
}






















