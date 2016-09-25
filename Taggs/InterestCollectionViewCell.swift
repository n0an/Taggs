//
//  InterestCollectionViewCell.swift
//  Taggs
//
//  Created by Anton Novoselov on 22/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class InterestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public API
    var interest: Interest! {
        didSet {
            updateUI()
        }
    }
    
    // MARK: - Private
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var interestTitleLabel: UILabel!
    
    fileprivate func updateUI()
    {
        interestTitleLabel?.text! = interest.title
        
        interest.featuredImageFile.getDataInBackground { (imageData, error) in
            
            if error == nil {
                
                if let featuredImageData = imageData {
                    self.featuredImageView.image = UIImage(data: featuredImageData)!
                }
                
            } else {
                print("\(error?.localizedDescription)")
            }
            
        }
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }

    
    
}
