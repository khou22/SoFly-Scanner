//
//  TextProcessing.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//

import Foundation

typealias TaggedToken = (String, String?)


// SEMANTIC OPERATIONS - THESE IDENTIFY PARTS OF SPEECH AND AND SEMANTIC RELATIONS
// OPEN SOURCE NFP
func tag(text: String, scheme: String) -> [TaggedToken] {
    let options: NSLinguisticTaggerOptions = .OmitWhitespace | .OmitPunctuation
    let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemesForLanguage("en"),
        options: Int(options.rawValue))
    tagger.string = text
    var tokens: [TaggedToken] = []
    tagger.enumerateTagsInRange(NSMakeRange(0, count(text)), scheme:scheme, options: options) {tag, tokenRange, _, _ in
        let token = (text as NSString).substringWithRange(tokenRange)
        tokens.append((token, tag))
    }
    return tokens
}

func partOfSpeech(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeLexicalClass)
}

func lemmatize(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeLemma)
}

func language(text: String) -> [TaggedToken] {
    return tag(text, NSLinguisticTagSchemeLanguage)
}


//FIRST PASS AT REMOVING EXTRA SPACES AND PUNCTUATION VOMIT
func preprocess(text: String) -> String {
	let myString = text
	let regex = try! NSRegularExpression(pattern: "\s+", options: NSRegularExpressionOptions.CaseInsensitive)
	let range = NSMakeRange(0, myString.characters.count)
	let modString = regex.stringByReplacingMatchesInString(myString, options: [], range: range, withTemplate: "\s")
	return punctuationElmination(modString)
}

func punctuationElmination(text: String) -> String {
	let myString = text
	let regex = try! NSRegularExpression(pattern: "(.|,|?|!)+", options: NSRegularExpressionOptions.CaseInsensitive)
	let range = NSMakeRange(0, myString.characters.count)
	let modString = regex.stringByReplacingMatchesInString(myString, options: [], range: range, withTemplate".")
}

funct dateFinder(text: String) -> String {
	let myString = text
	let regex = try! NSRegularExpression(pattern: "", options: NSRegularExpressionOptions.CaseInsensitive)
	let range = NSMakeRange(0, myString.characters.count)
}