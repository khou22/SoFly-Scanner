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
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var randomLabel: UILabel!
    
    override func viewDidLoad() {
        print("Completion screen loaded")
    }
    
    override func viewDidLayoutSubviews() {
        label.text = randomText
        print(randomText)
    }
    
    @IBAction func restartProcess(_ sender: Any) {
        performSegue(withIdentifier: Segues.completeToCamera, sender: nil)
    }
}
