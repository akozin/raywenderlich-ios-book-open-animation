//
//  BookLayout.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 01..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

private let PageWidth: CGFloat = 362
private let PageHeight: CGFloat = 568

class BookLayout: UICollectionViewLayout {
   
    var numberOfItems = 0
    
    override func prepareLayout() {
        super.prepareLayout()
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        numberOfItems = collectionView!.numberOfItemsInSection(0)
        collectionView?.pagingEnabled = true
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake((CGFloat(numberOfItems / 2)) * collectionView!.bounds.width, collectionView!.bounds.height)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var array: [UICollectionViewLayoutAttributes] = []
        for i in 0 ... max(0, numberOfItems - 1) {
            var indexPath = NSIndexPath(forItem: i, inSection: 0)
            var attributes = layoutAttributesForItemAtIndexPath(indexPath)
            if attributes != nil {
                array += [layoutAttributesForItemAtIndexPath(indexPath)]
            }
        }
        return array
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        // Create layout attributes object
        var layoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        // Set initial frame. Aligns the page's edge to the spine
        var frame = getFrame(collectionView!)
        layoutAttributes.frame = frame
        
        // Calculate ratio.
        // -1: The page is turned left, parallel to the plane of the screen.
        //  0: The page is facing towards the point of view.
        // +1: The page is turned right, parallel to the plane of the screen.
        var ratio = getRatio(collectionView!, indexPath: indexPath)
        
        // Make sure the cover is always visible
        if ratio < -1 || 1 < ratio  {
            if indexPath.row != 0 {
                return nil
            }
        }
        
        // Back-face culling. Only display front-face pages.
        if ratio > 0 && indexPath.item % 2 == 1
            || ratio < 0 && indexPath.item % 2 == 0 {
            if indexPath.row != 0 {
                return nil
            }
        }
        
        // Apply rotation transform
        var rotation = getRotation(indexPath, ratio: min(max(ratio, -1), 1))
        layoutAttributes.transform3D = rotation
        
        // Set z-index
        layoutAttributes.zIndex = Int(1000 * (1 - abs(ratio)))
        
        // Make sure the cover is always above page 1 to avoid flickering
        if indexPath.row == 0 {
            layoutAttributes.zIndex += 1
        }
        
        return layoutAttributes
    }
    
    func getFrame(collectionView: UICollectionView) -> CGRect {
        var frame = CGRect()
        
        frame.origin.x = collectionView.bounds.width / 2 - PageWidth / 2 + collectionView.contentOffset.x
        frame.origin.y = (collectionViewContentSize().height - PageHeight) / 2
        frame.size.width = PageWidth
        frame.size.height = PageHeight
        
        return frame
    }
    
    func getRatio(collectionView: UICollectionView, indexPath: NSIndexPath) -> CGFloat {
        let page = CGFloat(indexPath.item - indexPath.item % 2)
        var ratio: CGFloat = -0.5 + 0.5 * page - collectionView.contentOffset.x / collectionView.bounds.width
        
        if ratio > 0.5 {
            ratio = 0.5 + 0.1 * (ratio - 0.5)
        }
        
        if ratio < -0.5 {
            ratio = -0.5 + 0.1 * (ratio + 0.5)
        }
        
        return ratio
    }
    
    func makePerspectiveTransform() -> CATransform3D {
        var transform = CATransform3DIdentity;
        transform.m34 = 1.0 / -2000;
        return transform;
    }
    
    func getRotation(indexPath: NSIndexPath, ratio: CGFloat) -> CATransform3D {
        var transform = makePerspectiveTransform()
        
        // Set rotation
        var angle: CGFloat = 0
        
        if indexPath.item % 2 == 0 {
            angle = (1-ratio) * CGFloat(-M_PI_2) + CGFloat(indexPath.row % 2) * 0.001
        }
        
        if indexPath.item % 2 == 1 {
            angle = CGFloat(M_PI_2) + ratio * CGFloat(M_PI_2) + CGFloat(indexPath.row % 2) * 0.001
        }
        
        transform = CATransform3DRotate(transform, angle, 0, 1, 0)
        
        return transform
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
}
