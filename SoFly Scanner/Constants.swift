//
//  Constants.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

struct Options {
    static let GPUBlurRadius                    = CGFloat(25.0)
}

struct Colors {
    // Project colors
    static let lightPurple                      = UIColor(red: 164/255, green: 142/255, blue: 148/255, alpha: 1.0)
    static let darkPurple                       = UIColor(red: 80/255, green: 33/255, blue: 47/255, alpha: 1.0)
    static let lightGrey                    = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 1.0)
    static let grey                         = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0) // Summary card background
}

struct Images {
    // Image names
    static let captureImageButton               = "capture-image-button"
    static let captureImageButtonPressed        = "capture-image-button-pressed"
    static let iPhoneFull                       = "iphone-full"
    static let iPhoneWithDocument               = "iphone-with-document"
    static let scannerBar                       = "scanner-bar"
    
    // Test posters
    static let testPosterHackPrinceton          = "sample-poster-1"
    static let testPosterSimple                 = "sample-poster-2"
    static let testPosterSimpleDoubleSpaced     = "sample-poster-3"
    static let testPosterFrench                 = "sample-poster-french"
    static let testPosterCarWash                = "sample-poster-car-wash"
    static let testPosterEngHin                 = "sample-poster-eng+hin"
    static let testPosterGoogle                 = "sample-google-logo"
    static let testPosterHelloWorld             = "sample-hello-world"
    static let testSamplePicture                = "sample-picture-1"
    static let testPosterHPF2016                = "sample-poster-hp-f2016"
    static let testPosterPhoto1                 = "sample-poster-photo-1"
    static let testPosterPhotoiPhone            = "sample-poster-photo-iphone"
    static let testPosterFuzzyDice              = "sample-poster-fd"
}

struct Segues {
    static let landingToCamera                  = "LandingToCamera"
    static let cameraToLoading                  = "SegueToLoading"
    static let cameraToDebug                    = "SegueToDebug"
    static let processingToCompletion           = "SegueProcessingToCompletion"
    static let completeToCamera                 = "CompletionToCamera"
}

struct CellIdentifiers {
    static let autocompleteCell                 = "AutocompleteCell"
}
