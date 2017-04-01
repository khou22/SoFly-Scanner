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
    
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        print("Camera screen loaded")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let testImg = UIImage(named: Images.testPosterSimpleDoubleSpaced) {
            testImageView.image = ImageProcessing.scaleImage(image: testImg, maxDimension: 640)
            print("Testing image")
            let str = ImageProcessing.performImageRecognition(image: testImg)
            print(str)
        }
    }
    
}
