//
//  ProcessingScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class ProcessingScreen: UIViewController {
    
    var image: UIImage = UIImage()
    @IBOutlet weak var testUIImage: UIImageView!
    
    override func viewDidLoad() {
        print("Processing screen loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        testUIImage.image = image // Set image
    }
    
    override func viewDidLayoutSubviews() {
        ImageProcessing.testing(image: image)
    }
    
}
