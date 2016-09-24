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
        return interestIds.contains(interestId)
    }
    
    public func joinInterest(interestId: String) {
        self.interestIds.insert(interestId, at: 0)
        self.saveInBackground { (success, error) in
            if error != nil {
                print("\(error!.localizedDescription)")
            }
        }
    }
    
    
    
    
    // MARK: - PFSubclassing

    override public class func initialize() {
        
        self.registerSubclass()
        
        print("User PFSubclass initialize")
        
    }
    

}

