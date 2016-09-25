//
//  DiscoverTableViewCell.swift
//  Taggs
//
//  Created by nag on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

protocol DiscoverTableViewCellDelegate {
    func joinButtonClicked(interest: Interest!)
}

class DiscoverTableViewCell: UITableViewCell {
    
    // MARK: - PUBLIC API
    
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - OUTLETS

    @IBOutlet weak var backgroundViewWithShadow: CardView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    @IBOutlet weak var joinButton: InterestButton!
    @IBOutlet weak var interestFeaturedImage: UIImageView!
    @IBOutlet weak var interestDescriptionLabel: UILabel!
    
    // MARK: - PROPERTIES
    
    var delegate: DiscoverTableViewCellDelegate!

    
    // MARK: - updateUI

    func updateUI() {
        
        interestTitleLabel.text! = interest.title
        
        interest.featuredImageFile.getDataInBackground { (data, error) in
            if error == nil {
                
                if let imageData = data {
                    self.interestFeaturedImage.image = UIImage(data: imageData)!
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
        }
    
        interestDescriptionLabel.text! = interest.interestDescription
        
        // join button
        
        let currentUser = User.current()!
        
        if currentUser.isMemberOf(interestId: interest.objectId!) {
            joinButton.setTitle("→", for: .normal)

        } else {
            
            joinButton.setTitle("Join", for: .normal)
        }
        
        // change the color
        
        let randomColor = UIColor.randomColor()
        joinButton.color = randomColor
        
        interestTitleLabel.textColor = randomColor
        
    }
    
    // MARK: - ACTIONS

    @IBAction func joinButtonClicked(_ sender: InterestButton) {
        
        let currentUser = User.current()!
        
        if !currentUser.isMemberOf(interestId: interest.objectId!) {
            // let user to joing the interest
            currentUser.joinInterest(interestId: interest.objectId!)
            
            interest.incrementNumberOfMembers()
            
            joinButton.setTitle("→", for: .normal)
            
        } else {
            delegate?.joinButtonClicked(interest: interest)

        }
        
    }
}













