//
//  TextProcessing.swift
//  SoFly Scanner
//
//  Created by Kevin Hou on 3/31/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
import Foundation

typealias TaggedToken = (String, String?)

// Natural language processing class
class NaturalLangProcessing {
    // SEMANTIC OPERATIONS - THESE IDENTIFY PARTS OF SPEECH AND AND SEMANTIC RELATIONS
    // OPEN SOURCE NFP
    static func tag(text: String, scheme: String) -> [TaggedToken] {
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation]
        let tagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
            options: Int(options.rawValue))
        tagger.string = text
        var tokens: [TaggedToken] = []
        tagger.enumerateTags(in: NSMakeRange(0, text.characters.count), scheme: scheme, options: options, using: { tag, tokenRange, _, _ in
            let token = (text as NSString).substring(with: tokenRange)
            tokens.append((token, tag))
        })
        return tag(text: text, scheme: NSLinguisticTagSchemeLexicalClass)
    }

    static func lemmatize(text: String) -> [TaggedToken] {
        return tag(text: text, scheme: NSLinguisticTagSchemeLemma)
    }

    static func language(text: String) -> [TaggedToken] {
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

    static func dateFinder(text: String) -> String {
        let myString = text

        return myString
    }
}
