//
//  BooksViewController.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 06..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class BooksViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {
    
    var books: Array<Book>? {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    var transition: BookOpeningTransition?
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    var recognizer: UIGestureRecognizer? {
        didSet {
            if let recognizer = recognizer {
                collectionView?.addGestureRecognizer(recognizer)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        books = BookStore.sharedInstance.loadBooks("Books")
        recognizer = UIPinchGestureRecognizer(target: self, action: "handlePinch:")
    }
    
    // MARK: Helpers
    
    func selectedCell() -> BookCoverCell? {
        if let indexPath = collectionView?.indexPathForItemAtPoint(CGPointMake(collectionView!.contentOffset.x + collectionView!.bounds.width / 2, collectionView!.bounds.height / 2)) {
            if let cell = collectionView?.cellForItemAtIndexPath(indexPath) as? BookCoverCell {
                return cell
            }
        }
        return nil
    }
    
    // MARK: Gesture recognizer action
    
    func handlePinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .Began:
            if recognizer.scale >= 1 {
                if recognizer.view == collectionView {
                    interactionController = UIPercentDrivenInteractiveTransition()
                    var book = self.selectedCell()?.book
                    self.openBook(book)
                }
            }
            
            else {
                interactionController = UIPercentDrivenInteractiveTransition()
                navigationController?.popViewControllerAnimated(true)
            }
            
        case .Changed:
            if transition!.isPush {
                var progress = min(max(abs((recognizer.scale - 1)) / 5, 0), 1)
                interactionController?.updateInteractiveTransition(progress)
            }
            else {
                var progress = min(max(abs((1 - recognizer.scale)), 0), 1)
                interactionController?.updateInteractiveTransition(progress)
            }
            
        case .Ended:
            interactionController?.finishInteractiveTransition()
            interactionController = nil
            
        default:
            break
        }
    }
    
    func openBook(book: Book?) {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("BookViewController") as BookViewController
        vc.book = selectedCell()?.book
        // UICollectionView loads it's cells on a background thread, so make sure it's laoded before passing it to the animation handler
        vc.view.snapshotViewAfterScreenUpdates(true)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationController?.pushViewController(vc, animated: true)
            return
        })
    }
    
}

// MARK: UICollectionViewDelegate

extension BooksViewController: UICollectionViewDelegate {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var book = books?[indexPath.row]
        openBook(book)
    }
    
}

// MARK: UICollectionViewDataSource

extension BooksViewController: UICollectionViewDataSource {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let books = books {
            return books.count
        }
        return 0
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView .dequeueReusableCellWithReuseIdentifier("BookCoverCell", forIndexPath: indexPath) as BookCoverCell
        
        cell.book = books?[indexPath.row]
        
        return cell
    }
    
}

// MARK: UIViewControllerTransitioningDelegate

extension BooksViewController: UIViewControllerTransitioningDelegate {
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = BookOpeningTransition()
        transition.isPush = true
        transition.interactionController = interactionController
        self.transition = transition
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = BookOpeningTransition()
        transition.isPush = false
        transition.interactionController = interactionController
        self.transition = transition
        return transition
    }
    
}
