//
//  Post.swift
//  Taggs
//
//  Created by Anton Novoselov on 23/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

public class Post: PFObject, PFSubclassing {
    
    // MARK: - PUBLIC API
    
    @NSManaged public var user: PFUser
    @NSManaged public var postImageFile: PFFile!
    @NSManaged public var postText: String
    @NSManaged public var numberOfLikes: Int
    @NSManaged public var interestId: String!
    @NSManaged public var likedUserIds: [String]!

    // MARK: - Create new post
    
    override init() {
        super.init()
    }
    
    
    init(user: PFUser, postImage: UIImage!, postText: String, numberOfLikes: Int, interestId: String) {
        super.init()
        
        if postImage != nil {
            postImageFile = createFileFrom(image: postImage)
        } else {
            postImageFile = nil
        }
        
        self.user = user
        self.postText = postText
        self.numberOfLikes = numberOfLikes
        self.interestId = interestId
        self.likedUserIds = [String]()
    }
    
    
    // MARK: - Like / Dislike
    
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
        
        if likedUserIds.contains(currentUserObjectId) {
            numberOfLikes -= 1
            
            for (index, userId) in likedUserIds.enumerated() {
                if userId == currentUserObjectId {
                    likedUserIds.remove(at: index)
                    break
                }
            }
            self.saveInBackground()
        }
        
        
    }
    
    // MARK: - PFSubclassing
    
//    override public class func initialize() {
//        
//        self.registerSubclass()
//        
//        print("Post PFSubclass initialize")
//        
//    }
    
    public static func parseClassName() -> String {
        return "Post"
    }

    
    
}







