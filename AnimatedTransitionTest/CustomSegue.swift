//
//  CustomSegue.swift
//  AnimatedTransitionTest
//

import UIKit

class CustomSegue: UIStoryboardSegue {
    
    override func perform() {
        let src = self.sourceViewController
        let det = self.destinationViewController
        src.presentViewController(det, animated: true, completion: nil)
    }
}
