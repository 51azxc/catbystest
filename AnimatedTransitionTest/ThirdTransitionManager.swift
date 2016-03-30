//
//  ThirdTransitionManager.swift
//  AnimatedTransitionTest
//

import UIKit

class ThirdTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting:Bool = false
    private var interactive = false
    private var enterPanGesutre: UIScreenEdgePanGestureRecognizer!
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesutre = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesutre.addTarget(self, action: "handleOnStagePanGesture:")
            self.enterPanGesutre.edges = UIRectEdge.Left
            self.sourceViewController.view.addGestureRecognizer(self.enterPanGesutre)
        }
    }
    private var exitPanGesture: UIPanGestureRecognizer!
    var destinationViewController: UIViewController! {
        didSet {
            self.exitPanGesture = UIPanGestureRecognizer()
            self.exitPanGesture.addTarget(self, action: "handleOffStagePanGesture:")
            self.destinationViewController.view.addGestureRecognizer(self.exitPanGesture)
        }
    }
    
    var snapshot: UIView?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()!
        
        let screens: (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        let thirdViewController = !self.presenting ? screens.from as! ThirdViewController : screens.to as! ThirdViewController
        let viewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let thirdView = thirdViewController.view
        let view = viewController.view
        
        let moveRight = CGAffineTransformMakeTranslation(container.frame.width - 100, 0)
        let moveLeft = CGAffineTransformMakeTranslation(-250, 0)
        
        if self.presenting {
            thirdView.transform = moveLeft
            snapshot = view.snapshotViewAfterScreenUpdates(true)
        }
        
        container.addSubview(thirdView)
        container.addSubview(snapshot!)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
            
            if self.presenting {
                thirdView.transform = CGAffineTransformIdentity
                self.snapshot?.transform = moveRight
            } else {
                self.snapshot?.transform = CGAffineTransformIdentity
                thirdView.transform = moveLeft
            }
            
            }, completion: {
                finished in
                if transitionContext.transitionWasCancelled() {
                    transitionContext.completeTransition(false)
                    //UIApplication.sharedApplication().keyWindow?.addSubview(screens.from.view)
                } else {
                    transitionContext.completeTransition(true)
                    //UIApplication.sharedApplication().keyWindow?.addSubview(screens.to.view)
                }
                if !self.presenting {
                    self.snapshot?.removeFromSuperview()
                }
        })
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    func handleOnStagePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(gesture.view!)
        let d = translation.x / CGRectGetWidth(gesture.view!.bounds) * 0.5
        switch (gesture.state) {
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.sourceViewController.performSegueWithIdentifier("presentMe3", sender: self)
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveTransition(d)
        default:
            self.interactive = false
            if d > 0.2 {
                self.finishInteractiveTransition()
            } else {
                self.cancelInteractiveTransition()
            }
        }
    }
    
    func handleOffStagePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(gesture.view!)
        let d = translation.x / CGRectGetWidth(gesture.view!.bounds) * -0.5
        switch (gesture.state) {
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.destinationViewController.performSegueWithIdentifier("dismissMe3", sender: self)
        case UIGestureRecognizerState.Changed:
            self.updateInteractiveTransition(d)
        default:
            self.interactive = false
            if d > 0.1 {
                self.finishInteractiveTransition()
            } else {
                self.cancelInteractiveTransition()
            }
        }
    }
    
}
