//
//  ViewController.swift
//  AnimatedTransitionTest
//

import UIKit

class ViewController: UIViewController {

    let transitionManager = TransitionManager()
    let secondTransitionManager = SecondTransitionManager()
    let thirdTransitionManager = ThirdTransitionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.secondTransitionManager.sourceViewController = self
        self.thirdTransitionManager.sourceViewController = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.presentingViewController == nil ? UIStatusBarStyle.Default : UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "presentMe1" {
            let toViewController = segue.destinationViewController as UIViewController
            toViewController.transitioningDelegate = self.transitionManager
        } else if segue.identifier == "presentMe2" {
            let secondViewController = segue.destinationViewController as! SecondViewController
            secondViewController.transitioningDelegate = self.secondTransitionManager
            self.secondTransitionManager.destinationViewController = secondViewController
        } else if segue.identifier == "presentMe3" {
            let thirdViewController = segue.destinationViewController as! ThirdViewController
            thirdViewController.transitioningDelegate = self.thirdTransitionManager
            self.thirdTransitionManager.destinationViewController = thirdViewController
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    @IBAction func unwindToViewController(sender: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}

