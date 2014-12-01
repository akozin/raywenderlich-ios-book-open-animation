//
//  BookCoverCell.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 06..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class BookCoverCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var book: Book? {
        didSet {
            image = book?.coverImage()
        }
    }
    
    var image: UIImage? {
        didSet {
            var corners: UIRectCorner = .TopRight | .BottomRight
            imageView.image = image!.imageByScalingAndCroppingForSize(bounds.size).imageWithRoundedCornersSize(20, corners: corners)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAntialiasing()
    }
    
    func setupAntialiasing() {
        layer.allowsEdgeAntialiasing = true
        imageView.layer.allowsEdgeAntialiasing = true
    }
    
}
