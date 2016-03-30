//
//  TransitionManager.swift
//  AnimatedTransitionTest
//

import UIKit

class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    var presenting:Bool = false
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let offScreenDown = CGAffineTransformMakeTranslation(0, -container.frame.height)
        let offScreenUp = CGAffineTransformMakeTranslation(0, container.frame.height)
        
        toView.transform = self.presenting ? offScreenDown : offScreenUp
        
        container.addSubview(toView)
        container.addSubview(fromView)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.CurveLinear, animations: {
            fromView.transform = self.presenting ? offScreenUp : offScreenDown
            toView.transform = CGAffineTransformIdentity
            }, completion: {
                finished in
                transitionContext.completeTransition(true)
        })
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
}

