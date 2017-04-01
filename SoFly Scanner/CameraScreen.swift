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

class CameraScreen: UIViewController, AVCapturePhotoCaptureDelegate {
    
    // Live camera view
    @IBOutlet weak var cameraPreview: UIView!
    
    // Camera UI Elements
    @IBOutlet weak var captureImageButton: UIButton!
    
    // Data
    var finalImage = UIImage()
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        styling() // Add UI styling
        startCameraSession() // Start camera session
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let testImg = UIImage(named: Images.testPosterPhotoiPhone) {
//            ImageProcessing.testing(image: testImg) // Testing
        }
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
        
        captureImage() // Capture image
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
    
    func captureImage() {
        // Make sure image output is still live
        if let _ = self.sessionOutput.connection(withMediaType: AVMediaTypeVideo) {
            
            // Photo settings
            let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG]) // Capture as JPEG
            
            // Capture the image
            sessionOutput.capturePhoto(with: photoSettings, delegate: self) // Callback below
            print("Captured")
        }
    }
    
    // Called when photo is captured
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        // Show errors if any
        if let error = error {
            print(error.localizedDescription)
        }
        
        if let image = UIImage(data: AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer)!) {
            
            // MARK - have UIImage from camera
            processImage(image: image) // Process
            
        } else { // Image can't be created from data
            print("Error in constructing image")
        }
    }
    
    // Called when image is grabbed from camera
    func processImage(image: UIImage) {
        finalImage = image // Set as global
        
        // Segue to next screen
        performSegue(withIdentifier: Segues.cameraToLoading, sender: nil)
//        performSegue(withIdentifier: Segues.cameraToDebug, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // If going to loading screen
        if (segue.identifier == Segues.cameraToLoading) {
            
            // Segue to the loading page
            let loadingScreen = segue.destination as! ProcessingScreen // Get VC
            loadingScreen.image = finalImage // Pass on image
            
        } else if (segue.identifier == Segues.cameraToDebug) { // Debugging
            // Segue to the debugger page
            let debugScreen = segue.destination as! DebugScreen // Get VC
            debugScreen.image = finalImage // Pass on image
        }
    }
}
