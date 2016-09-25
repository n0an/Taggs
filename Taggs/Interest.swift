//
//  Interest.swift
//  Taggs
//
//  Created by Anton Novoselov on 22/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

public class Interest: PFObject, PFSubclassing {
    
    
    // MARK: - Public API

    @NSManaged public var title: String!
    @NSManaged public var interestDescription: String!
    @NSManaged public var numberOfMembers: Int
    @NSManaged public var numberOfPosts: Int
    @NSManaged public var featuredImageFile: PFFile

    public func incrementNumberOfPosts() {
        numberOfPosts += 1
        self.saveInBackground()
    }
    
    public func incrementNumberOfMembers() {
        numberOfMembers += 1
        self.saveInBackground()
    }
    
    
    // MARK: - Convenience init
    
    override init() {
        super.init()
    }
    
    init(title: String, interestDescription: String, imageFile: PFFile, numberOfMembers: Int, numberOfPosts: Int) {
        super.init()
        
        self.title = title
        self.interestDescription = interestDescription
        self.featuredImageFile = imageFile
        self.numberOfMembers = numberOfMembers
        self.numberOfPosts = numberOfPosts
        
        
    }
    
    
    // MARK: - PFSubclassing
    
//    override public class func initialize() {
//        
//        self.registerSubclass()
//        
//        print("Interest PFSubclass initialize")
//        
//    }

    public static func parseClassName() -> String {
        return "Interest"
    }

}
