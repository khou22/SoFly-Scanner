//
//  HorizontalSegue.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/1/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class SegueSlideLeftToRight: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        // Don't allow user interaction
        dst.view.isUserInteractionEnabled = false
        src.view.isUserInteractionEnabled = false
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view) // Add view
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0) // Transform off screen
        
        // Animate horizontal segue
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseInOut], animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { finished in
            src.present(dst, animated: false, completion: nil)
            
            // Normal functionality
            src.view.isUserInteractionEnabled = true
            dst.view.isUserInteractionEnabled = true
        })
    }
}

class SegueSlideRightToLeft: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        // Don't allow user interaction
        dst.view.isUserInteractionEnabled = false
        src.view.isUserInteractionEnabled = false
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view) // Add view
        dst.view.transform = CGAffineTransform(translationX: -src.view.frame.size.width, y: 0) // Transform off screen
        
        // Animate horizontal segue
        UIView.animate(withDuration: 0.35, delay: 0.0, options: [.curveEaseInOut], animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }, completion: { finished in
            src.present(dst, animated: false, completion: nil)
            
            // Normal functionality
            src.view.isUserInteractionEnabled = true
            dst.view.isUserInteractionEnabled = true
        })
    }
}
