//
//  BookOpeningTransition.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 07..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class BookOpeningTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isPush = true
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    var transforms = [UICollectionViewCell: CATransform3D]()
    
    // MARK: UIViewControllerAnimatedTransitioning
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        if isPush {
            return 1
        } else {
            return 1
        }
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        
        if isPush {
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as BooksViewController
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as BookViewController
            
            container.addSubview(fromVC.view)
            container.addSubview(toVC.view)
            
            toVC.view.alpha = 0
            
            var toViewBackgroundColor = fromVC.collectionView?.backgroundColor
            toVC.collectionView?.backgroundColor = nil
            
            self.setStartPositionForPush(fromVC, toVC: toVC)
            toVC.view.alpha = 1
            fromVC.selectedCell()?.alpha = 0
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: nil, animations: {
                self.setEndPositionForPush(fromVC, toVC: toVC)
            }, completion: { finished in
                toVC.collectionView?.backgroundColor = toViewBackgroundColor
                transitionContext.completeTransition(finished)
                toVC.recognizer = fromVC.recognizer
            })
        }
            
        else {
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as BookViewController
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as BooksViewController
            
            container.addSubview(toVC.view)
            container.addSubview(fromVC.view)
            
            var toViewBackgroundColor = fromVC.collectionView?.backgroundColor
            fromVC.collectionView?.backgroundColor = nil
            
            var transforms = [UICollectionViewCell: CATransform3D]()
            
            UIView.animateWithDuration(self.transitionDuration(transitionContext), animations: {
                self.setEndPositionForPop(fromVC, toVC: toVC)
            }, completion: { finished in
                fromVC.collectionView?.backgroundColor = toViewBackgroundColor
                transitionContext.completeTransition(finished)
                toVC.recognizer = fromVC.recognizer
                toVC.selectedCell()?.alpha = 1
            })
        }
    }
    
    func setStartPositionForPush(fromVC: BooksViewController, toVC: BookViewController) {
        for cell in toVC.collectionView!.visibleCells() as [BookPageCell] {
            transforms[cell] = cell.layer.transform
            
            var transform = self.makePerspectiveTransform()
            if cell.layer.anchorPoint.x == 0 {
                transform = CATransform3DRotate(transform, CGFloat(0), 0, 1, 0)
                transform = CATransform3DTranslate(transform, -0.7 * cell.layer.bounds.width / 2, 0, 0)
                transform = CATransform3DScale(transform, 0.7, 0.7, 1)
            } else {
                transform = CATransform3DRotate(transform, CGFloat(-M_PI), 0, 1, 0)
                transform = CATransform3DTranslate(transform, 0.7 * cell.layer.bounds.width / 2, 0, 0)
                transform = CATransform3DScale(transform, 0.7, 0.7, 1)
            }
            
            cell.layer.transform = transform
            cell.updateShadowLayer()
        }
    }
    
    func setEndPositionForPush(fromVC: BooksViewController, toVC: BookViewController) {
        for cell in fromVC.collectionView!.visibleCells() as [BookCoverCell] {
            cell.alpha = 0
        }

        for cell in toVC.collectionView!.visibleCells() as [BookPageCell] {
            cell.layer.transform = transforms[cell]!
            cell.updateShadowLayer(animated: true)
        }
    }
    
    func setEndPositionForPop(fromVC: BookViewController, toVC: BooksViewController) {
        let coverCell = toVC.selectedCell()
        for cell in toVC.collectionView!.visibleCells() as [BookCoverCell] {
            if cell != coverCell {
                cell.alpha = 1
            }
        }
        
        for cell in fromVC.collectionView!.visibleCells() as [BookPageCell] {
            var transform = self.makePerspectiveTransform()
            if cell.layer.anchorPoint.x == 0 {
                transform = CATransform3DRotate(transform, CGFloat(0), 0, 1, 0)
                transform = CATransform3DTranslate(transform, -0.7 * cell.layer.bounds.width / 2, 0, 0)
                transform = CATransform3DScale(transform, 0.7, 0.7, 1)
            } else {
                transform = CATransform3DRotate(transform, CGFloat(-M_PI), 0, 1, 0)
                transform = CATransform3DTranslate(transform, 0.7 * cell.layer.bounds.width / 2, 0, 0)
                transform = CATransform3DScale(transform, 0.7, 0.7, 1)
            }
            cell.layer.transform = transform
        }
    }
    
    func makePerspectiveTransform() -> CATransform3D {
        var transform = CATransform3DIdentity;
        transform.m34 = 1.0 / -2000;
        return transform;
    }
    
}
