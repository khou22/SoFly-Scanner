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
    
    // Camera UI Elements
    @IBOutlet weak var captureImageButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        styling() // Add UI styling
        startCameraSession() // Start camera session
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        testing() // Testing
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.previewLayer.frame = cameraPreview.bounds // Set bounds
    }
    
    // Styling
    func styling() {
        // MARK - Capture image button styling
        self.captureImageButton.imageView?.contentMode = .scaleAspectFit // Image fit
        captureImageButton.setImage(UIImage(named: Images.captureImageButtonPressed), for: .focused) // Different image when pressed
        
        // Add shadow to capture image button
        self.captureImageButton.layer.shadowColor = UIColor.black.cgColor
        self.captureImageButton.layer.shadowOffset = CGSize(width: 5, height: 5)
        self.captureImageButton.layer.shadowRadius = 5.0
    }
    
    // User presses button to take picture
    @IBAction func captureImage(_ sender: Any) {
        print("Capturing image")
    }
    
    // Start camera session
    func startCameraSession() {
        // MARK - setup live camera view
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
    
    func testing() {
        if let testImg = UIImage(named: Images.testPosterHackPrinceton) {
            print("Testing image")
            let str = ImageProcessing.performImageRecognition(image: testImg)
            print(str)
            
            let preprocessed: String = NaturalLangProcessing.preprocess(text: str)
            print(preprocessed)
            
            print(NaturalLangProcessing.lemmatize(text: preprocessed))
        }
    }
}
