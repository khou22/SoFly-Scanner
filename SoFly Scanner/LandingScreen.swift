//
//  LandingScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 4/1/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class LandingScreen: UIViewController {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var logoWithRed: UIImageView!
    
    override func viewDidLoad() {
        // Unit testing
        if let testImg = UIImage(named: Images.testPosterSimple) {
            print(ImageProcessing.testing(image: testImg)) // Testing
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        startAnimation() // Start animations
    }
    
    func startAnimation() {
        
        // Flash red light on camera logo
        UIView.animate(withDuration: 0.5, delay: 0.2, animations: {
            self.logoWithRed.alpha = 0.0
        }, completion: { (_) in
            UIView.animate(withDuration: 0.05, delay: 0.2, animations: {
                self.logoWithRed.alpha = 1.0
            }, completion: { (_) in
                UIView.animate(withDuration: 0.05, delay: 0.2, animations: {
                    self.logoWithRed.alpha = 0.0
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.05, delay: 0.2, animations: {
                        self.logoWithRed.alpha = 1.0
                    }, completion: { (_) in
                        UIView.animate(withDuration: 0.05, delay: 0.2, animations: {
                            self.logoWithRed.alpha = 0.0
                        }, completion: { (_) in
                            self.generateFlash() // Flash and segue
                        })
                    })
                })
            })
        })
    }
    
    // Generate a flash animation and segue to main app
    func generateFlash() { // Flash animation
        let shutterView = UIView(frame: view.frame) // Fill entire screen
        shutterView.backgroundColor = UIColor.white // White flash
        view.insertSubview(shutterView, aboveSubview: self.logo) // Add to view
        shutterView.alpha = 0.0 // Start transparent
        
        UIView.animate(withDuration: 0.2, animations: {
            shutterView.alpha = 1.0 // Reveal flash
        }, completion: { (_) in
            shutterView.removeFromSuperview()
            
            self.performSegue(withIdentifier: Segues.landingToCamera, sender: nil)
        })
    }
}
