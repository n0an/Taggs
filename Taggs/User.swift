//
//  User.swift
//  Taggs
//
//  Created by Anton Novoselov on 23/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

class User: PFUser {
    
    @NSManaged public var interestIds: [String]!
    @NSManaged public var profileImageFile: PFFile!
    
    public func isMemberOf(interestId: String) -> Bool {
        
        if interestIds == nil {
            return false
        } else {
            return interestIds.contains(interestId)

        }
        
    }
    
    public func joinInterest(interestId: String) {
        print("self.interestIds BEFORE = \(self.interestIds)")

        
        if self.interestIds == nil {
            self.interestIds = [interestId]
        } else {
            self.interestIds.insert(interestId, at: 0)
            
        }
        
        self.saveInBackground { (success, error) in
            if error != nil {
                print("\(error!.localizedDescription)")
            }
        }
        
        
        
    }
    
    init(username: String, password: String, email: String, image: UIImage) {
        super.init()
        
        let imageFile = createFileFrom(image: image)
        
        self.profileImageFile = imageFile
        self.username = username
        self.password = password
        self.email = email
        self.interestIds = []
    }
    
    override init() {
        super.init()
    }

    
    
    
    
    // MARK: - PFSubclassing

//    override public class func initialize() {
//        
//        self.registerSubclass()
//        
//        print("User PFSubclass initialize")
//        
//    }
    

}

