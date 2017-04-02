//Algorithm borrowed from Ayaka Nonaka
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.

import Foundation

// default constant for model approximation
private let sp = 1.0

public class MLModule {
    public typealias Word = String
    public typealias Category = String

    private var categoryOccurrences: [Category: Int] = [:]
    private var wordOccurrences: [Word: [Category: Int]] = [:]
    private var trainingCount = 0
    private var wordCount = 0

    public func trainWithText(text: String, category: Category) {
        let tokens = NaturalLangProcessing.tag(text: text, scheme: NSLinguisticTagSchemeLemma).keys as! [Word]
        trainWithTokens(tokens: tokens, category: category)
    }

    
    public func trainWithTokens(tokens: [Word], category: Category) {
        let words = Set(tokens)
        for word in words {
            incrementWord(word: word, category: category)
        }
        incrementCategory(category: category)
        trainingCount += 1
    }

 
    public func classify(text: String) -> Category? {
        let tokens = NaturalLangProcessing.tag(text: text, scheme: NSLinguisticTagSchemeLemma).keys as! [Word]
        return classifyTokens(tokens: tokens)
    }

    
    public func classifyTokens(tokens: [Word]) -> Category? {
        var champion: Category = Category()
        var maxScore: Double = 0
        
        for (_, category1) in categoryOccurrences.enumerated() {
            let category: Category = category1.key
            let pCategory = self.P(category: category)
            let score = tokens.reduce(log(pCategory)) { (total, token) in
                total + log((self.P(category: category, token) + sp) / (pCategory + sp + Double(self.wordCount)))
            }
            
            if score > maxScore {
                // Update champions
                champion = category
                maxScore = score
            }
        }
        
        return champion // Return champion
    }

  
    private func P(category: Category, _ word: Word) -> Double {
        if let occurrences = wordOccurrences[word] {
            let count = occurrences[category] ?? 0
            return Double(count) / Double(trainingCount)
        }
        return 0.0
    }

    private func P(category: Category) -> Double {
        return Double(totalOccurrencesOfCategory(category: category)) / Double(trainingCount)
    }

  
    private func incrementWord(word: Word, category: Category) {
        if wordOccurrences[word] == nil {
            wordCount += 1
            wordOccurrences[word] = [:]
        }

        let count = wordOccurrences[word]?[category] ?? 0
        wordOccurrences[word]?[category] = count + 1
    }

    private func incrementCategory(category: Category) {
        categoryOccurrences[category] = totalOccurrencesOfCategory(category: category) + 1
    }

    private func totalOccurrencesOfWord(word: Word) -> Int {
        if let occurrences = wordOccurrences[word] {
            return Array(occurrences.values).reduce(0, +)
        }
        return 0
    }

    private func totalOccurrencesOfCategory(category: Category) -> Int {
        return categoryOccurrences[category] ?? 0
    }

}
