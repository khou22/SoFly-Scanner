﻿//
//  TextProcessing.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
import Foundation

let TaggedToken: [String : String] = [:]

// Natural language processing class
class NaturalLangProcessing {
    // SEMANTIC OPERATIONS - THESE IDENTIFY PARTS OF SPEECH AND AND SEMANTIC RELATIONS
    // OPEN SOURCE NFP
    static func tag(text: String, scheme: String) -> [String : String] {
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation]
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
            options: Int(options.rawValue))
        tagger.string = text
        var tokens: [String : String] = [:]
        tagger.enumerateTags(in: NSMakeRange(0, text.characters.count), scheme: scheme, options: options, using: { tag, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange)
            tokens.updateValue(tag, forKey: token)
        })
        return tokens
    }

    static func lemmatize(text: String) -> [String : String] {
        return tag(text: text, scheme: NSLinguisticTagSchemeLemma)
    }

    static func language(text: String) -> [String : String] {
        return tag(text: text, scheme: NSLinguisticTagSchemeLanguage)
    }


    // FIRST PASS AT REMOVING EXTRA SPACES AND PUNCTUATION VOMIT
    static func preprocess(text: String) -> String {
        let myString = text
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "\\s+", options: .caseInsensitive)
        let range: NSRange = NSMakeRange(0, myString.characters.count)
        let modString = regex.stringByReplacingMatches(in: myString, options: [], range: range, withTemplate: " ")

        return punctuationElmination(text: modString)
    }

    static func punctuationElmination(text: String) -> String {
      let myString = text
        let regex: NSRegularExpression = try! NSRegularExpression(pattern: "(\\.|,|\\?|!)+", options: .caseInsensitive)
        let range: NSRange = NSMakeRange(0, myString.characters.count)
        let modString = regex.stringByReplacingMatches(in: myString, options: [], range: range, withTemplate: ".")

        return modString
    }

    static func Year(text: String) -> String {
        let myString = text as NSString
        let regex1: NSRegularExpression = try! NSRegularExpression(pattern: "201.", options: .caseInsensitive)
        let regex2: NSRegularExpression = try! NSRegularExpression(pattern: "1.", options: .caseInsensitive)

        let range: NSRange = NSMakeRange(0, myString.characters.count)
        let modString1 = regex1.matches(myString, options:[], range:range)
		let modString2 = regex2.matches(myString, options:[], range:range)
		let f: [String] = modString1.map{mySting.substring($0.range)}
		let l: [String] = modString2.map{myString.substring($0.range)}
        var temp: String
		if (!f.isEmpty) {
			return f[0]
		}
		return l[0]
    }
}
