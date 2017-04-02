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
import GPUImage // Color control

class CameraScreen: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Live camera view
    @IBOutlet weak var cameraPreview: UIView!
    
    // Camera UI Elements
    @IBOutlet weak var captureImageButton: UIButton!
    let imagePicker = UIImagePickerController() // Initialize an image picker view controller type
    
    // Other UI elements
    var fadeIn: UIView = UIView()
    
    // Data
    var finalImage = UIImage()
    
    var captureSession = AVCaptureSession()
    var sessionOutput = AVCapturePhotoOutput()
    var sessionOutputSetting = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    override func viewDidLoad() {
        imagePicker.delegate = self
    }
    
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
        captureImageButton.isEnabled = false // Make sure won't be pressed again
        
        // Animate button fade
        UIView.animate(withDuration: 0.4, animations: {
            self.captureImageButton.alpha = 0.0 // Make transparent
        })
        
        captureImage() // Capture image
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        self.pickImage(sourceType: .photoLibrary) // Presents image picker
    }
    
    func pickImage(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.allowsEditing = false // Prevent editing
        
        // Three sources: .PhotoLibrary, .Camera, .SavedPhotosAlbum
        self.imagePicker.sourceType = sourceType // Type of image selection
        
        // Presenting image picker view controller on top of stack
        self.present(self.imagePicker, animated: true, completion: {
            print("Opening image picker view controller")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
        self.captureSession.stopRunning() // Freeze the camera
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.finalImage = image // Save global
            
            // Go to loading screen
            self.performSegue(withIdentifier: Segues.cameraToLoading, sender: nil)
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.finalImage = image // Save global
            
            // Go to loading screen
            self.performSegue(withIdentifier: Segues.cameraToLoading, sender: nil)
        } else{
            print("Something went wrong")
        }
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
                        captureSession.sessionPreset = AVCaptureSessionPreset640x480 // Change to lower resolution
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
        self.finalImage = image // Set as global
        
        let stillImageFilter: GPUImageAdaptiveThresholdFilter = GPUImageAdaptiveThresholdFilter()
        stillImageFilter.blurRadiusInPixels = Options.GPUBlurRadius // Blur radius of the filter, defaults to 4.0
        let scannedImage: UIImage = stillImageFilter.image(byFilteringImage: image) // Make filtered image
        let scanOverlay: UIImageView = UIImageView(frame: view.frame) // Create view
        scanOverlay.image = scannedImage // Set image
        scanOverlay.contentMode = .scaleAspectFill // Aspect fill
        scanOverlay.alpha = 0.0 // Make transparent
        self.cameraPreview.addSubview(scanOverlay) // Add view
        UIView.animate(withDuration: 0.5, animations: {
            scanOverlay.alpha = 1.0 // Make visible
        })
        
        // Segue to next screen after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
            // Go to loading screen
            self.performSegue(withIdentifier: Segues.cameraToLoading, sender: nil)
            
            // If debugging image processing
//            self.performSegue(withIdentifier: Segues.cameraToDebug, sender: nil)
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
