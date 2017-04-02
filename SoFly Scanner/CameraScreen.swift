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
    
    // Other UI elements
    var fadeIn: UIView = UIView()
    
    // Data
    var finalImage = UIImage()
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewWillAppear(_ animated: Bool) {
        // Fade the camera view in
        self.fadeIn = UIView(frame: view.frame) // Fill entire screen
        fadeIn.backgroundColor = UIColor.white // Start as white
        view.insertSubview(fadeIn, aboveSubview: cameraPreview) // Insert above everything
        
        styling() // Add UI styling
        startCameraSession() // Start camera session
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Fade the screen in
        UIView.animate(withDuration: 1.0, animations: {
            self.fadeIn.backgroundColor = UIColor.clear // Make transparent
        }, completion: { (_) in
            self.fadeIn.removeFromSuperview() // Remove view
        })
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
                    print("Exception!")
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
        }
    }
    
    // Called when photo is captured
    func capture(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        self.captureSession.stopRunning() // Freeze the frame
        
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
        
        // Segue to next screen after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            // Go to loading screen
//            self.performSegue(withIdentifier: Segues.cameraToLoading, sender: nil)
            
            // If debugging image processing
            self.performSegue(withIdentifier: Segues.cameraToDebug, sender: nil)
        })
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
