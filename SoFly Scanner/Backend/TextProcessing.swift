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
        let regex1: NSRegularExpression = try! NSRegularExpression(pattern: "201[0-9](\\.| |\\\\|,)", options: .caseInsensitive)
        let regex2: NSRegularExpression = try! NSRegularExpression(pattern: "1[0-9](\\.| |\\\\|,)", options: .caseInsensitive)
        
        
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
        
        if (!l.isEmpty) {
            return l[0]
        }
        
        return "2017"
    }
    
    // The Date function pulls sections of text that contain the Weekday, the Month, then the Day (aka like the 15th). It returns these in a way that can be split and mapped to numeric 
    // consistent values. JAN, January, JaNuAry all map to 01, this is a [String: Int] dictionary that i will fb chat u
    static func PullDate(text: String) -> String {
        let myString = text as NSString
//        let regexFullMonths: NSRegularExpression = try! NSRegularExpression(pattern: "?(Mon(\\.|day) |Tues?(\\.|day) |Wed?(\\.|nesday) |Thu?(rs)?(\\.|day) |Fri?(\\.|day) |Sat?(\\.|urday) |Sun?(\\.|day) )?(\\s+)?(Jan(\\.| |uary)|Feb(\\.| |ruary)|Mar(\\.| |ch)|Apr(\\.| |il)|May|Jun(\\.| |e)|Jul(\\.|y| )|Aug(\\.| |ust)|Sep?(t)(\\.|ember| )|Oct(\\.| |ober)|Nov(\\.|ember|)|Dec(\\.| |ember|)?(\\s+)?(on |on the |in )?(?(0)[1-9]|[1-2][0-9]|30|31)?(\\.|-|\\\\| |st|th|nd)", options: .caseInsensitive)
        
        let regexFullMonths: NSRegularExpression = try! NSRegularExpression(pattern: "(Mon?(\\.|day) |Tues?(\\.|day) |Wed?(\\.|nesday) |Thu?(rs)?(\\.|day) |Fri?(\\.|day) |Sat?(\\.|urday)|Sun?(\\.|day) | )(\\s*)(Jan(\\.| |uary)|Feb(\\.| |ruary)|Mar(\\.| |ch) |Apr(\\.| |il)|May|Jun(\\.| |e)|Jul(\\.|y| )|Aug(\\.| |ust)|Sep?(t)(\\.|ember| )|Oct(\\.| |ober)|Nov(\\.|ember|)|Dec(\\.| |ember|))(\\s*)?([1-9]|(0)[1-9]|[1-2][0-9]|30|31)?(\\.|-|\\\\| |st|th|nd)", options: .caseInsensitive)

        
        let range: NSRange = NSMakeRange(0, myString.length)
        let modString1 = regexFullMonths.matches(in: myString as String, options:[], range:range)
        let f: [String] = modString1.map{myString.substring(with: $0.range)}
            
        if (!f.isEmpty) {
            return f[0]
        } else {
            return "SUNDAY JANUARY 01"
        }
    }
    
    static func Month(text: String) -> String {
        let myString = text as NSString
        let regexFullMonths: NSRegularExpression = try! NSRegularExpression(pattern: "(January |February |March |April |May |June |July |August |September |October |November |December )((|0)[1-9]|[1-2][0-9]|30|31)(\\.|-|\\\\| |st|th|nd)", options: .caseInsensitive)
        let regexAbbrevs: NSRegularExpression = try! NSRegularExpression(pattern: "(Jan |Feb |Mar |Apr |May |Jun |Jul |Aug |Sept |Sep |Oct |Nov |Dec |Jan\\. |Feb\\. |Mar\\. |Apr\\. |May\\. |Jun\\. |Jul\\. |Aug\\. |Sept\\. |Sep\\. |Oct\\. |Nov\\. |Dec\\. )(| )((|0)[1-9]|[1-2][0-9]|30|31)(\\.|-|\\\\| |st|th|nd)", options: .caseInsensitive)
        let regexNumeric: NSRegularExpression = try! NSRegularExpression(pattern: "([1-9]|0[1-9]|1[0-2])(\\.|-| |\\\\)(| )((|0)[1-9]|[1-2][0-9]|30|31)(\\.|-|\\\\| |st|th|nd)", options: .caseInsensitive)
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
        else if (!m.isEmpty) {
            return m[0]
        }
        else {
            return "JAN"
        }
    }
    
//    static func Day(text: String) -> [String] {
//        let myString = text as NSString
//        let regex1: NSRegularExpression = try! NSRegularExpression(pattern: "((|0)[1-9]|[1-2][0-9]|30|31)(\\.|-|\\\\| |st|th|nd)", options: .caseInsensitive)
//        let range: NSRange = NSMakeRange(0, myString.length)
//        let modString1 = regex1.matches(in: myString as String, options:[], range:range)
//        let f: [String] = modString1.map{
//            myString.substring(with: $0.range)
//        }
//        if (f.isEmpty) {
//            return ["{Unknown}"]
//        }
//        return f
//    }
//    
    static func Time(text: String) -> String {
        let myString = text as NSString
        let regexColon: NSRegularExpression = try! NSRegularExpression(pattern: "(0[1-9]||[0-9]|1[0-2]):(0[0-9]|[10-59])", options: .caseInsensitive)
        let regexNumberAMPM: NSRegularExpression = try! NSRegularExpression(pattern: "([1-9]|1[0-2]) (am|pm)", options: .caseInsensitive)
        let regexAMPM: NSRegularExpression = try! NSRegularExpression(pattern: "(am|pm) ", options: .caseInsensitive)
        let range: NSRange = NSMakeRange(0, myString.length)

        let modString1 = regexColon.matches(in: myString as String, options:[], range:range)
        let modString2 = regexNumberAMPM.matches(in: myString as String, options:[], range:range)
        let modString3 = regexAMPM.matches(in: myString as String, options:[], range:range)
        let f: [String] = modString1.map{myString.substring(with: $0.range)}
        let l: [String] = modString2.map{myString.substring(with: $0.range)}
        let m: [String] = modString3.map{myString.substring(with: $0.range)}

        
        if (!f.isEmpty) {
            return f[0]
        }
        else if(!l.isEmpty) {
            return l[0]
        }
        else if (!m.isEmpty) {
            return m[0]
        }
        else {
            return "12:00 AM"
        }
    }
    
    
    
    ////////// Machine Learning / AI Stuff
    //////////////////////////////////////////////
//    public func trainWithText(text: String, category: Category) {
//        trainWithTokens(tokenizer(text), category: category)
//    }
//    
//    public func trainWithTokens(tokens: [String], category: Category) {
//        let tokens = Set(tokens)
//        for token in tokens {
//            incrementToken(token, category: category)
//        }
//        incrementCategory(category)
//        trainingCount++
//    }
//    
//    // MARK: - Classifying
//    
//    public func classifyText(text: String) -> Category? {
//        return classifyTokens(tokenizer(text))
//    }
//    
//    public func classifyTokens(tokens: [String]) -> Category? {
//        var maxCategory: Category?
//        var maxCategoryScore = -Double.infinity
//        for (category, _) in categoryOccurrences {
//            let pCategory = P(category)
//            let score = tokens.reduce(log(pCategory)) { (total, token) in
//                total + log((P(category, token) + smoothingParameter) / (pCategory + smoothingParameter * Double(tokenCount)))
//            }
//            if score > maxCategoryScore {
//                maxCategory = category
//                maxCategoryScore = score
//            }
//        }
//        return maxCategory
//    }
}
