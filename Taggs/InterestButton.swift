//
//  InterestButton.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class InterestButton: UIButton {
    
    // MARK: - Public API
    
    var color = UIColor.lightGray {
        didSet {
            borderColor = self.color.cgColor
            self.layer.borderColor = self.borderColor
            buttonTintColor = self.color
            self.tintColor = buttonTintColor
        }
    }
    
    // MARK: - Private
    
    fileprivate var borderWidth: CGFloat = 2.0
    fileprivate var cornerRadius: CGFloat = 3.0
    fileprivate var buttonTintColor: UIColor = UIColor.lightGray
    fileprivate var borderColor: CGColor = UIColor.lightGray.cgColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderColor = self.color.cgColor
        buttonTintColor = self.color
        
        layer.borderColor = self.borderColor
        layer.borderWidth = self.borderWidth
        layer.cornerRadius = self.cornerRadius
        layer.masksToBounds = true
        self.tintColor = buttonTintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}


