//
//  UIImage+Helpers.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 16..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

extension UIImage {
    
    func imageWithRoundedCornersSize(cornerRadius: CGFloat, corners: UIRectCorner) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        UIBezierPath(roundedRect: CGRectMake(00, 0, self.size.width, self.size.height), byRoundingCorners: corners, cornerRadii: CGSizeMake(cornerRadius, cornerRadius)).addClip()
        drawInRect(CGRectMake(0, 0, self.size.width, self.size.height))
        
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func imageByScalingAndCroppingForSize(targetSize: CGSize) -> UIImage {
        var sourceImage = self
        var newImage = UIImage()
        var imageSize = sourceImage.size
        var width = imageSize.width
        var height = imageSize.height
        var targetWidth = targetSize.width
        var targetHeight = targetSize.height
        var scaleFactor: CGFloat = 0.0
        var scaledWidth = targetWidth
        var scaledHeight = targetHeight
        var thumbnailPoint = CGPointMake(0.0,0.0)
        
        if CGSizeEqualToSize(imageSize, targetSize) == false {
            var widthFactor = targetWidth / width
            var heightFactor = targetHeight / height
            
            if (widthFactor > heightFactor) {
                scaleFactor = widthFactor
            }
                
            else {
                scaleFactor = heightFactor
            }
            
            scaledWidth  = width * scaleFactor
            scaledHeight = height * scaleFactor
            
            if (widthFactor > heightFactor) {
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
            }
                
            else if (widthFactor < heightFactor) {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
            }
        }
        
        UIGraphicsBeginImageContext(targetSize)
        
        var thumbnailRect = CGRectZero
        thumbnailRect.origin = thumbnailPoint
        thumbnailRect.size.width  = scaledWidth
        thumbnailRect.size.height = scaledHeight
        
        sourceImage.drawInRect(thumbnailRect)
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}
