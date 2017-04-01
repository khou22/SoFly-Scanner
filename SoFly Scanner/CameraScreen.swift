//
//  CameraScreen.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation // Camera control

class CameraScreen: UIViewController {
    
    // Live camera view
    @IBOutlet weak var cameraPreview: UIView!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        let deviceDiscoverySession = AVCaptureDeviceDiscoverySession(deviceTypes: [.builtInDuoCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: AVMediaTypeVideo, position: .unspecified) // Build list of all devices that satisfy this requirement
        
        for device in (deviceDiscoverySession?.devices)! { // Cycle through all requirements
            if (device.position == AVCaptureDevicePosition.back) { // Use back camera
                do {
                    let input = try AVCaptureDeviceInput(device: device) // Try the current input
                    if (captureSession.canAddInput(input)) { // If valid
                        captureSession.addInput(input) // Add input to session
                        
                        if (captureSession.canAddOutput(sessionOutput)) { // If can also take pictures
                            captureSession.addOutput(sessionOutput) // Add to output
                            
                            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                            previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                            previewLayer.connection.videoOrientation = .portrait // Portrait orientation
                            
                            self.cameraPreview.layer.addSublayer(previewLayer) // Add the preview
                            
                            captureSession.startRunning() // Start the camera session
                            
                            break // Break out of loop
                        }
                    }
                }
                catch {
                    print("exception!")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let testImg = UIImage(named: Images.testPosterHackPrinceton) {
            print("Testing image")
            let str = ImageProcessing.performImageRecognition(image: testImg)
            print(str)
            
            let preprocessed: String = NaturalLangProcessing.preprocess(text: str)
            print(preprocessed)
            
            print(NaturalLangProcessing.lemmatize(text: preprocessed))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.previewLayer.frame = cameraPreview.bounds // Set bounds
    }
    
}
