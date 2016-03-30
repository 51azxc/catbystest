//
//  SecondTransitionmanager.swift
//  AnimatedTransitionTest
//

import UIKit

class SecondTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting:Bool = false
    private var interactive = false
    private var enterPanGesutre: UIScreenEdgePanGestureRecognizer!
    var sourceViewController: UIViewController! {
        didSet {
            self.enterPanGesutre = UIScreenEdgePanGestureRecognizer()
            self.enterPanGesutre.addTarget(self, action: "handleOnStagePanGesture:")
            self.enterPanGesutre.edges = UIRectEdge.Right
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
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.75
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()!
        
        let screens: (from:UIViewController, to:UIViewController) = (transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!, transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!)
        
        let secondViewController = !self.presenting ? screens.from as! SecondViewController : screens.to as! SecondViewController
        let viewController = !self.presenting ? screens.to as UIViewController : screens.from as UIViewController
        
        let secondView = secondViewController.view
        let view = viewController.view
        
        if self.presenting {
            if self.interactive {
                self.offStageControllerInteractive(secondViewController)
            } else {
                self.offStageController(secondViewController)
            }
        }
        
        container.addSubview(view)
        container.addSubview(secondView)
        
        UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.CurveLinear, animations: {
            if self.presenting {
                self.onStageController(secondViewController)
            } else if self.interactive {
                self.offStageControllerInteractive(secondViewController)
            } else {
                self.offStageController(secondViewController)
            }
            }, completion: {
                finished in
                if transitionContext.transitionWasCancelled() {
                    transitionContext.completeTransition(false)
                } else {
                    transitionContext.completeTransition(true)
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
    
    func offStageController(viewController: SecondViewController) {
        viewController.view.alpha = 0
        
        let topRowOffset:CGFloat = 300
        let middleRowOffset:CGFloat = 150
        let bottomRowOffset:CGFloat = 50
        
        viewController.label1.transform = CGAffineTransformMakeTranslation(-topRowOffset, 0)
        viewController.label2.transform = CGAffineTransformMakeTranslation(topRowOffset, 0)
        
        viewController.label3.transform = CGAffineTransformMakeTranslation(-middleRowOffset, 0)
        viewController.label4.transform = CGAffineTransformMakeTranslation(middleRowOffset, 0)
        
        viewController.label5.transform = CGAffineTransformMakeTranslation(-bottomRowOffset, 0)
        viewController.label6.transform = CGAffineTransformMakeTranslation(bottomRowOffset, 0)
    }
    
    func onStageController(viewController: SecondViewController) {
        viewController.view.alpha = 1
        
        viewController.label1.transform = CGAffineTransformIdentity
        viewController.label2.transform = CGAffineTransformIdentity
        
        viewController.label3.transform = CGAffineTransformIdentity
        viewController.label4.transform = CGAffineTransformIdentity
        
        viewController.label5.transform = CGAffineTransformIdentity
        viewController.label6.transform = CGAffineTransformIdentity
    }
    
    func offStageControllerInteractive(viewController: SecondViewController) {
        viewController.view.alpha = 0
        
        let offStageOffset: CGFloat = 300
        
        viewController.label1.transform = CGAffineTransformMakeTranslation(offStageOffset, 0)
        viewController.label2.transform = CGAffineTransformMakeTranslation(offStageOffset, 0)
        
        viewController.label3.transform = CGAffineTransformMakeTranslation(offStageOffset, 0)
        viewController.label4.transform = CGAffineTransformMakeTranslation(offStageOffset, 0)
        
        viewController.label5.transform = CGAffineTransformMakeTranslation(offStageOffset, 0)
        viewController.label6.transform = CGAffineTransformMakeTranslation(offStageOffset, 0)
    }
    
    func handleOnStagePanGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translationInView(gesture.view!)
        let d = translation.x / CGRectGetWidth(gesture.view!.bounds) * -0.5
        switch (gesture.state) {
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.sourceViewController.performSegueWithIdentifier("presentMe2", sender: self)
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
        let d = translation.x / CGRectGetWidth(gesture.view!.bounds) * 0.5
        switch (gesture.state) {
        case UIGestureRecognizerState.Began:
            self.interactive = true
            self.destinationViewController.performSegueWithIdentifier("dismissMe2", sender: self)
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
