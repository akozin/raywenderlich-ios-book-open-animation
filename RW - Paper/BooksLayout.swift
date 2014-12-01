//
//  BooksLayout.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 06..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

private let PageWidth: CGFloat = 362
private let PageHeight: CGFloat = 568

class BooksLayout: UICollectionViewFlowLayout {
    
    var numberOfItems = 0

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        itemSize = CGSizeMake(PageWidth, PageHeight)
        minimumInteritemSpacing = 10
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        
        collectionView?.decelerationRate = UIScrollViewDecelerationRateFast
        
        // Make sure the first book is centered.
        collectionView?.contentInset = UIEdgeInsets(
            top: 0,
            left: collectionView!.bounds.width / 2 - PageWidth / 2,
            bottom: 0,
            right: collectionView!.bounds.width / 2 - PageWidth / 2
        )
        
        numberOfItems = collectionView!.numberOfItemsInSection(0)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        var array = super.layoutAttributesForElementsInRect(rect) as [UICollectionViewLayoutAttributes]
        
        for attributes in array {
            var frame = attributes.frame
            var distance = abs(collectionView!.contentOffset.x + collectionView!.contentInset.left - frame.origin.x)
            var scale = 0.7 * min(max(1 - distance / (collectionView!.bounds.width), 0.75), 1)
            attributes.transform = CGAffineTransformMakeScale(scale, scale)
        }
        
        return array
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        // Snap cells to centre
        var newOffset = CGPoint()
        
        var layout = collectionView!.collectionViewLayout as UICollectionViewFlowLayout
        var width = layout.itemSize.width + layout.minimumLineSpacing
        var offset = proposedContentOffset.x + collectionView!.contentInset.left
        
        if velocity.x > 0 {
            offset = width * ceil(offset / width)
        }
        
        if velocity.x == 0 {
            offset = width * round(offset / width)
        }
        
        if velocity.x < 0 {
            offset = width * floor(offset / width)
        }
        
        newOffset.x = offset - collectionView!.contentInset.left
        newOffset.y = proposedContentOffset.y
        
        return newOffset
    }
    
}
