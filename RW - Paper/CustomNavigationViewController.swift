//
//  CustomNavigationViewController.swift
//  RW - Paper
//
//  Created by Attila on 2014. 12. 07..
//  Copyright (c) 2014. -. All rights reserved.
//

import UIKit

class CustomNavigationViewController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        // Check if the parent view controller implements interactive transitioning
        if operation == .Push {
            if let vc = fromVC as? UIViewControllerTransitioningDelegate {
                return vc.animationControllerForPresentedController?(toVC, presentingController: fromVC, sourceController: UIViewController())
            }
        }
        
        if operation == .Pop {
            if let vc = toVC as? UIViewControllerTransitioningDelegate {
                return vc.animationControllerForDismissedController?(fromVC)
            }
        }
        
        return nil
    }

    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // Check if the animationController is a BookOpeningTransition
        if let animationController = animationController as? BookOpeningTransition {
            return animationController.interactionController
        }
        return nil
    }
    
}
