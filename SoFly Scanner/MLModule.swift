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

    private let tokenizer: Tokenizer

    private var categoryOccurrences: [Category: Int] = [:]
    private var wordOccurrences: [Word: [Category: Int]] = [:]
    private var trainingCount = 0
    private var wordCount = 0

    public init(tokenizer: Tokenizer = Tokenizer()) {
        self.tokenizer = tokenizer
    }

  
    public func trainWithText(text: String, category: Category) {
        let tokens = tokenizer.tokenize(text)
        trainWithTokens(tokens, category: category)
    }

    
    public func trainWithTokens(tokens: [Word], category: Category) {
        let words = Set(tokens)
        for word in words {
            incrementWord(word, category: category)
        }
        incrementCategory(category)
        trainingCount++
    }

 
    public func classify(text: String) -> Category? {
        let tokens = tokenizer.tokenize(text)
        return classifyTokens(tokens)
    }

    
    public func classifyTokens(tokens: [Word]) -> Category? {
    
        return argmax(categoryOccurrences.map { (category, count) -> (Category, Double) in
            let pCategory = self.P(category)
            let score = tokens.reduce(log(pCategory)) { (total, token) in
                total + log((self.P(category, token) + sp) / (pCategory + sp + Double(self.wordCount)))
            }
            return (category, score)
        })
    }

  
    private func P(category: Category, _ word: Word) -> Double {
        if let occurrences = wordOccurrences[word] {
            let count = occurrences[category] ?? 0
            return Double(count) / Double(trainingCount)
        }
        return 0.0
    }

    private func P(category: Category) -> Double {
        return Double(totalOccurrencesOfCategory(category)) / Double(trainingCount)
    }

  
    private func incrementWord(word: Word, category: Category) {
        if wordOccurrences[word] == nil {
            wordCount++
            wordOccurrences[word] = [:]
        }

        let count = wordOccurrences[word]?[category] ?? 0
        wordOccurrences[word]?[category] = count + 1
    }

    private func incrementCategory(category: Category) {
        categoryOccurrences[category] = totalOccurrencesOfCategory(category) + 1
    }

    private func totalOccurrencesOfWord(word: Word) -> Int {
        if let occurrences = wordOccurrences[word] {
            return Array(occurrences.values).reduce(0, combine: +)
        }
        return 0
    }

    private func totalOccurrencesOfCategory(category: Category) -> Int {
        return categoryOccurrences[category] ?? 0
    }

}