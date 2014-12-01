//
//  ViewController.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 01..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class BookViewController: UICollectionViewController {
    
    var book: Book? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var recognizer: UIGestureRecognizer? {
        didSet {
            if let recognizer = recognizer {
                collectionView?.addGestureRecognizer(recognizer)
            }
        }
    }
    
}

// MARK: UICollectionViewDataSource

extension BookViewController: UICollectionViewDataSource {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let book = book {
            return book.numberOfPages() + 1
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView .dequeueReusableCellWithReuseIdentifier("BookPageCell", forIndexPath: indexPath) as BookPageCell
        
        if indexPath.row == 0 {
            // Cover page
            cell.textLabel.text = nil
            cell.image = book?.coverImage()
        }
            
        else {
            // Page with index: indexPath.row - 1
            cell.textLabel.text = "\(indexPath.row)"
            cell.image = book?.pageImage(indexPath.row - 1)
        }
        
        return cell
    }
    
}
