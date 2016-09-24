//
//  TestObject.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

// TODO: - Make singleton, using dispatch_once analog

class TestObject: PFObject, PFSubclassing {
    
    @NSManaged public var title: String!
    @NSManaged public var objectDescription: String!
    @NSManaged public var numbers: Int
    
    override public class func initialize() {
        
        self.registerSubclass()
        
        print("TestObject PFSubclass initialize")

    }
    
    public static func parseClassName() -> String {
        return "TestObject"
    }
    
}
