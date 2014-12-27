//
//  BookPageCell.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 01..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class BookPageCell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var book: Book?
    
    var image: UIImage? {
        didSet {
            var corners: UIRectCorner = !isRightPage ? .TopRight | .BottomRight : .TopLeft | .BottomLeft
            imageView.image = image!.imageByScalingAndCroppingForSize(bounds.size).imageWithRoundedCornersSize(20, corners: corners)
        }
    }
    
    func updateShadowLayer(animated: Bool = false) {
        var ratio: CGFloat = 0
        
        // Get ratio from transform. Check BookCollectionViewLayout for more details
        var inverseRatio = 1 - abs(getRatioFromTransform())
        
        if !animated {
            CATransaction.begin()
            CATransaction.setDisableActions(!animated)
        }
        
        if isRightPage {
            // Right page
            shadowLayer.colors = NSArray(objects:
                UIColor.darkGrayColor().colorWithAlphaComponent(inverseRatio * 0.45).CGColor,
                UIColor.darkGrayColor().colorWithAlphaComponent(inverseRatio * 0.40).CGColor,
                UIColor.darkGrayColor().colorWithAlphaComponent(inverseRatio * 0.55).CGColor
            )
            shadowLayer.locations = NSArray(objects:
                NSNumber(float: 0.00),
                NSNumber(float: 0.02),
                NSNumber(float: 1.00)
            )
        } else {
            // Left page
            shadowLayer.colors = NSArray(objects:
                UIColor.darkGrayColor().colorWithAlphaComponent(inverseRatio * 0.30).CGColor,
                UIColor.darkGrayColor().colorWithAlphaComponent(inverseRatio * 0.40).CGColor,
                UIColor.darkGrayColor().colorWithAlphaComponent(inverseRatio * 0.50).CGColor,
                UIColor.darkGrayColor().colorWithAlphaComponent(inverseRatio * 0.55).CGColor
            )
            shadowLayer.locations = NSArray(objects:
                NSNumber(float: 0.00),
                NSNumber(float: 0.50),
                NSNumber(float: 0.98),
                NSNumber(float: 1.00)
            )
        }
        
        if !animated {
            CATransaction.commit()
        }
    }
    
    func getRatioFromTransform() -> CGFloat {
        var ratio: CGFloat = 0
        
        var rotationY = CGFloat(layer.valueForKeyPath("transform.rotation.y")!.floatValue!)
        if isRightPage {
            var progress = -(1 - rotationY / CGFloat(M_PI_2))
            ratio = progress
        }
            
        else {
            var progress = 1 - rotationY / CGFloat(-M_PI_2)
            ratio = progress
        }
        
        return ratio
    }
    
    var isRightPage: Bool = false
    
    var shadowLayer: CAGradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAntialiasing()
        initShadowLayer()
    }
    
    func setupAntialiasing() {
        layer.allowsEdgeAntialiasing = true
        imageView.layer.allowsEdgeAntialiasing = true
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        super.applyLayoutAttributes(layoutAttributes)
        if layoutAttributes.indexPath.item % 2 == 0 {
            // The book's spine is on the left of the page
            layer.anchorPoint = CGPointMake(0, 0.5)
            isRightPage = false
        } else {
            // The book's spine is on the right of the page
            layer.anchorPoint = CGPointMake(1, 0.5)
            isRightPage = true
        }
        
        self.updateShadowLayer()
    }

    func initShadowLayer() {
        var shadowLayer = CAGradientLayer()
        
        shadowLayer.frame = bounds
        shadowLayer.startPoint = CGPointMake(0, 0.5)
        shadowLayer.endPoint = CGPointMake(1, 0.5)
        
        self.imageView.layer.addSublayer(shadowLayer)
        self.shadowLayer = shadowLayer
    }
    
    override var bounds: CGRect {
        didSet {
            shadowLayer.frame = bounds
        }
    }
    
}
