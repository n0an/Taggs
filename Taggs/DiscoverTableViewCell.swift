//
//  DiscoverTableViewCell.swift
//  Taggs
//
//  Created by nag on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

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
//        interestFeaturedImage.image! = interest.featuredImage
        interestDescriptionLabel.text! = interest.description
        
        joinButton.setTitle("→", for: .normal)
        
    }
    
    // MARK: - ACTIONS

    @IBAction func joinButtonClicked(_ sender: InterestButton) {
        delegate?.joinButtonClicked(interest: interest)
    }
}







