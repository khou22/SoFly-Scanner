//
//  FadeSegue.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/1/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

class FadeSegue: UIStoryboardSegue {
    // 'source' refers to the source VC
    // 'destination' refers to the destination VC
    
    // Automatically called when segue is performed
    override func perform() {
        let window = UIApplication.shared.keyWindow!
        
        destination.view.alpha = 0.0
        window.insertSubview(destination.view, belowSubview: source.view)
        
        // Fade animation
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.source.view.alpha = 0.0
            self.destination.view.alpha = 1.0
        }) { (finished) -> Void in
            self.source.view.alpha = 1.0
            self.source.present(self.destination, animated: false, completion: nil)
        }
    }
}
