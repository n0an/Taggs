//
//  Comment.swift
//  Taggs
//
//  Created by Anton Novoselov on 24/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

public class Comment: PFObject, PFSubclassing {
    
    @NSManaged public var postId: String!
    @NSManaged public var user: PFUser!
    @NSManaged public var commentText: String!
    @NSManaged public var numberOfLikes: Int
    @NSManaged public var likedUserIds: [String]!
    
    // MARK: - Like/dislike comment by current user
    
    public func like() {
        
        let currentUserObjectId = User.current()!.objectId!
        if !likedUserIds.contains(currentUserObjectId) {
            numberOfLikes += 1
            likedUserIds.insert(currentUserObjectId, at: 0)
            self.saveInBackground()
        }
    }
    
    public func dislike() {
        
        let currentUserObjectId = User.current()!.objectId!
        if let index = likedUserIds.index(of: currentUserObjectId) {
            numberOfLikes -= 1
            likedUserIds.remove(at: index)
            self.saveInBackground()
        }
    }
    
    override init() {
        super.init()
    }
    
    // MARK: - create new comment
    
    init(postId: String, user: PFUser, commentText: String, numberOfLikes: Int) {
        
        super.init()
        
        self.postId = postId
        self.user = user
        self.commentText = commentText
        self.numberOfLikes = numberOfLikes
        self.likedUserIds = [String]()
    }
    
    // MARK: - Register, call this before register for Parse
    
    // MARK: - PFSubclassing
    
    override public class func initialize() {
        
        self.registerSubclass()
        
        print("Comment PFSubclass initialize")
        
    }
    
    public static func parseClassName() -> String {
        return "Comment"
    }

    
    
}
