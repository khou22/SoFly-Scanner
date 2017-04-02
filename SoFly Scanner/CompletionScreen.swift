//
//  CompletionScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit

class CompletionScreen: UIViewController {
    
    var image: UIImage = UIImage() // Store image
    var randomText: String = ""
    @IBOutlet weak var randomLabel: UILabel!
    
    override func viewDidLoad() {
        print("Completion screen loaded")
    }
    
    override func viewDidLayoutSubviews() {
        print(randomText)
    }
    
}
