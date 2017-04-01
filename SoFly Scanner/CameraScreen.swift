//
//  CameraScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CameraScreen: UIViewController {
    
    override func viewDidLoad() {
        print("Camera screen loaded")
        
        if let testImg = UIImage(named: "sample-poster") {
            let str = ImageProcessing.performImageRecognition(image: testImg)
            print(str)
        }
    }
    
}
