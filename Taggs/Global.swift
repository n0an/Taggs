//
//  Global.swift
//  Taggs
//
//  Created by Anton Novoselov on 25/09/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Parse

// ===TOUSE===
// SHRINK RESIZE IMAGE

// MARK: - IMAGE HANDLER


public func createFileFrom(image: UIImage) -> PFFile! {
    
    let ratio = image.size.width / image.size.height
    
    let resizedImage = resizeImage(originalImage: image, toWidth: ImageSize.height * ratio, andHeight: ImageSize.height)
    
    let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)!
    
    return PFFile(name: "image.jpg", data: imageData)
}

fileprivate struct ImageSize {
    static let height: CGFloat = 480.0
}

fileprivate func resizeImage(originalImage: UIImage, toWidth width: CGFloat, andHeight height: CGFloat) -> UIImage {
    
    let newSize = CGSize(width: width, height: height)
    let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
    
    UIGraphicsBeginImageContext(newSize)
    
    originalImage.draw(in: newRectangle)
    
    let resizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return resizedImage
}
