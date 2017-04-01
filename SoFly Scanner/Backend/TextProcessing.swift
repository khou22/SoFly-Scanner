//
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
        let regex1: NSRegularExpression = try! NSRegularExpression(pattern: "201[0-9]", options: .caseInsensitive)
        let regex2: NSRegularExpression = try! NSRegularExpression(pattern: "1[0-9]", options: .caseInsensitive)
        
        
        let range: NSRange = NSMakeRange(0, myString.length)
        let modString1 = regex1.matches(in: myString as String, options:[], range:range)
        let modString2 = regex2.matches(in: myString as String, options:[], range:range)
        
        let f: [String] = modString1.map{
            myString.substring(with: $0.range)
        }
        let l: [String] = modString2.map{
            myString.substring(with: $0.range)
        }
        
        if (!f.isEmpty) {
            return f[0]
        }
        return l[0]
    }
    
    static func Month(text: String) -> String {
        let myString = text as NSString
        let regexFullMonths: NSRegularExpression = try! NSRegularExpression(pattern: "(January |February |March |April |May |June |July |August |September |October |November |December )", options: .caseInsensitive)
        let regexAbbrevs: NSRegularExpression = try! NSRegularExpression(pattern: "(Jan |Feb |Mar |Apr |May |Jun |Jul |Aug |Sept |Sep |Oct |Nov |Dec |Jan\\. |Feb\\. |Mar\\. |Apr\\. |May\\. |Jun\\. |Jul\\. |Aug\\. |Sept\\. |Sep\\. |Oct\\. |Nov\\. |Dec\\. )", options: .caseInsensitive)
        let regexNumeric: NSRegularExpression = try! NSRegularExpression(pattern: "([1-9]|0[1-9]|1[0-2])(\\.|-| |\\\\)", options: .caseInsensitive)
        let range: NSRange = NSMakeRange(0, myString.length)
        let modString1 = regexFullMonths.matches(in: myString as String, options:[], range:range)
        let modString2 = regexAbbrevs.matches(in: myString as String, options:[], range:range)
        let modString3 = regexNumeric.matches(in: myString as String, options:[], range:range)
        let f: [String] = modString1.map{myString.substring(with: $0.range)}
        let l: [String] = modString2.map{myString.substring(with: $0.range)}
        let m: [String] = modString3.map{myString.substring(with: $0.range)}
        
        if (!f.isEmpty) {
            return f[0]
        }
        else if(!l.isEmpty) {
            return l[0]
        }
        else {
            return m[0]
        }
    }
    
    static func Year(text: String) -> [String] {
        let myString = text as NSString
        let regex1: NSRegularExpression = try! NSRegularExpression(pattern: "0[1-9]|[1-31](\\.|-|\\\\| )", options: .caseInsensitive)
        let range: NSRange = NSMakeRange(0, myString.length)
        let modString1 = regex1.matches(in: myString as String, options:[], range:range)
        let f: [String] = modString1.map{
            myString.substring(with: $0.range)
        }
        return f
    }
    
    static func Time(text: String) -> [String] {
        let regexColon: NSRegularExpression = try! NSRegularExpression(pattern: "(0[1-9]||[0-9]|1[0-2]):(0[0-9]|[10-59])", options: .caseInsensitive)
        let regexNumberAMPM: NSRegularExpression = try! NSRegularExpression(pattern: "[1-12](am|pm)(\\\\|.|-| )", options: .caseInsensitive)
        let regexAMPM: NSRegularExpression = try! NSRegularExpression(pattern: "", options: .caseInsensitive)
        return []
    }
}
