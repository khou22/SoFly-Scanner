//
//  AutocompleteTextField.swift
//  Calendar Event Template App
//
//  Created by Kevin Hou on 1/17/17.
//  Copyright © 2017 Kevin Hou. All rights reserved.
//
//  Autocomplete table view for any UITextField

import UIKit

class AutocompleteTextField: UITextField, UITextFieldDelegate {
    
    // Relevant data
    fileprivate var autocompleteSuggestions: [String] = [] // All possible suggestions in order of priority
    fileprivate var validSuggestions: [String] = [] // Matches textfield's value
    
    fileprivate var autocompleteTableView: UITableView = UITableView()
    
    // Next text field after user presses return
    public var nextTextField: UITextField = UITextField()
    
    // Styling
    public var cellHeight: CGFloat = 40.0
    public var numCellsVisible: Int = 3
    public var padding: CGFloat = 7.0
    fileprivate var tableHeight: CGFloat = 40.0 * 3 // Default value is three cell heights
    
    // Options
    public var characterError: Int = 2 // Degree of error you're allowed to be off by using Levenshtein algorithm
    
    // Not sure what this does
    override init(frame: CGRect) {
        super.init(frame: frame) // Initialize text field?
    }
    
    // Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        
        // Setup function triggers on events
        self.addTarget(self, action: #selector(self.valueChanged), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nextTextField.becomeFirstResponder() // Next responder
        return true
    }
    
    // Entrance animation for suggestion box
    func showSuggestions() {
        let oldFrame = self.autocompleteTableView.frame // Store old frame
        UIView.animate(withDuration: 0.15, animations: {
            self.autocompleteTableView.alpha = 1.0 // Show animation box
            self.autocompleteTableView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: self.tableHeight) // Animate expand
        })
    }
    
    // Exit animation for suggestion box
    func hideSuggestions() {
        let oldFrame = self.autocompleteTableView.frame // Store old frame
        UIView.animate(withDuration: 0.15, animations: {
            self.autocompleteTableView.alpha = 0.0 // Doesn't have to be 0
            self.autocompleteTableView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: 0.0) // Animate shrink
        })
    }
    
    // Update possible suggestions
    func updateSuggestions(prioritized suggestions: [String]) {
        self.autocompleteSuggestions = suggestions // Update data source
    }
    
    // Update the valid/matching suggestions
    func updateValid() {
        let currentQuery: String = self.text!.uppercased() // Make uppercase so not case sensitive
        
        if (currentQuery == "") { // If the textbox is empty
            self.validSuggestions = self.autocompleteSuggestions // Load all as potentially valid
        } else { // If the user has typed something into the text box
            self.validSuggestions.removeAll() // Clear array
            // Cycle through all possible and search for matches
            for potential in self.autocompleteSuggestions {
                var potentialCaseFree: String = potential.uppercased() // Uppercase so not case sensitive
                
                var valid = false // Track if valid
                
                if currentQuery.characters.count <= 2 { // If only one letter in search query
                    valid = potentialCaseFree.contains(currentQuery) // If exact match, set true
                    
                } else { // If more than one letter in search query
                    if (currentQuery.characters.count < potentialCaseFree.characters.count) { // If the query is less than the result
                        potentialCaseFree = potentialCaseFree.substring(to: currentQuery.endIndex) // Only compare substrings of the same length
                    }
                    
//                    print("Comparing: \(potentialCaseFree) and \(currentQuery)") // Debugging
                    
                    // If Levenshtein distance is within specified range
                    valid = potentialCaseFree.getLevenshtein(target: currentQuery) <= self.characterError
                }
                
                if valid { // If valid autocomplete suggestion
                    self.validSuggestions.append(potential) // Add to the secondary array
                }
            }
        }
        
        self.updateTableViewHeight() // Update table height to sync with number of suggestions
        
        // Refresh table view
        DispatchQueue.main.async {
            self.autocompleteTableView.reloadData()
        }
    }
    
    // Began editing event name — text box is focused
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateValid() // Updates autocomplete suggestions
        self.showSuggestions() // Show autocomplete suggestions
    }
    
    // Clicked away/not focused on editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideSuggestions() // Hide autocomplete suggestions
    }
    
    // Text field value changed
    public func valueChanged() {
        self.updateValid() // Update autocomplete suggestions when value changed
    }
    
    func updateTableViewHeight() {
        if (self.validSuggestions.count < self.numCellsVisible) { // If fewer suggestions than cells visible
            self.tableHeight = self.cellHeight * CGFloat(self.validSuggestions.count) // Calculate height
            self.autocompleteTableView.isScrollEnabled = false // Turn off scrolling if less cells than max
        } else { // Only display max amount, but allow scrolling
            self.tableHeight = self.cellHeight * CGFloat(self.numCellsVisible) // Calculate height
            self.autocompleteTableView.isScrollEnabled = true // Allow scrolling to rest of cells
        }
        
        // Refresh table height
        let oldFrame = self.autocompleteTableView.frame // Store old frame
        self.autocompleteTableView.frame = CGRect(x: oldFrame.minX, y: oldFrame.minY, width: oldFrame.width, height: self.tableHeight) // Update table height
    }
}


// Everything relating to the suggestion table view frontend
extension AutocompleteTextField: UITableViewDelegate, UITableViewDataSource {
    
    // Setup autcomplete table view
    public func setupTableView(view: UIView) {
        // Starts below text input, same width
        let lowerLeftCorner: CGPoint = CGPoint(x: self.frame.minX, y: self.frame.maxY) // Get coordinate of text input
        let transformedOrigin: CGPoint = (self.superview?.convert(lowerLeftCorner, to: view))! // Transform point into view frame
        let frame = CGRect(x: transformedOrigin.x, y: transformedOrigin.y + self.padding, width: self.frame.width, height: self.tableHeight)
        self.autocompleteTableView = UITableView(frame: frame)
        
        // Set data source and delegate
        self.autocompleteTableView.delegate = self
        self.autocompleteTableView.dataSource = self
        
        // Register cell
        self.autocompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.autcompleteCell)
        
        // Styling
        self.autocompleteTableView.rowHeight = self.cellHeight // Row height
        self.autocompleteTableView.alpha = 0.0 // Start transparent when initialized (must be 0)
        self.autocompleteTableView.separatorColor = Colors.lightGrey // Seperator color
        self.autocompleteTableView.separatorInset = .zero // No seperator line inset
        
        // Options
        self.autocompleteTableView.isScrollEnabled = true // Allow scrolling
        
        // Set border
        self.autocompleteTableView.layer.borderWidth = 1 // Set border
        self.autocompleteTableView.layer.cornerRadius = 5 // Set border radius
        self.autocompleteTableView.layer.borderColor = Colors.grey.cgColor // Border color
        
        view.addSubview(autocompleteTableView) // Add to view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.autocompleteTableView.dequeueReusableCell(withIdentifier: CellIdentifiers.autcompleteCell, for: indexPath)
        
        // Styling
        cell.textLabel?.font = cell.textLabel?.font.withSize(12.0) // Set font size
        cell.textLabel?.textColor = Colors.black
        cell.backgroundColor = Colors.white
        
        // Populate information
        cell.textLabel?.text = self.validSuggestions[indexPath.item] // Populate cell label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.validSuggestions.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.text = self.validSuggestions[indexPath.item] // Push suggestion to text box value
        self.nextTextField.becomeFirstResponder() // Next responder
    }
}


/*************** Levenshtein Difference ***************/
//  Levenshtein difference between two strings
//  Source: https://gist.github.com/TheDarkCode/341ec5b84c078a0be1887c2c58f6d929
//  Reference: https://en.wikipedia.org/wiki/Levenshtein_distance
//
//  I updated the code from Swift 2 to Swift 3

import Foundation

fileprivate extension String {
    
    func getLevenshtein(target: String) -> Int {
        return levenshtein(sourceString: self, target: target)
    }
    
}

// Minimize 3
fileprivate func min3(a: Int, b: Int, c: Int) -> Int {
    
    return min( min(a, c), min(b, c))
    
}

fileprivate extension String {
    
    subscript(index: Int) -> Character {
        
        return self[index]
        
    }
    
    subscript(range: Range<Int>) -> String {
        
        return self[range.lowerBound..<range.upperBound]
        
    }
    
}

fileprivate struct Array2D {
    
    var columns: Int
    var rows: Int
    var matrix: [Int]
    
    
    init(columns: Int, rows: Int) {
        
        self.columns = columns
        
        self.rows = rows
        
        matrix = Array(repeating:0, count:columns*rows)
        
    }
    
    subscript(column: Int, row: Int) -> Int {
        
        get {
            
            return matrix[columns * row + column]
            
        }
        
        set {
            
            matrix[columns * row + column] = newValue
            
        }
        
    }
    
    func columnCount() -> Int {
        
        return self.columns
        
    }
    
    func rowCount() -> Int {
        
        return self.rows
        
    }
}

fileprivate func levenshtein(sourceString: String, target targetString: String) -> Int {
    
    let source = Array(sourceString.unicodeScalars)
    let target = Array(targetString.unicodeScalars)
    
    let (sourceLength, targetLength) = (source.count, target.count)
    
    var distance = Array2D(columns: sourceLength + 1, rows: targetLength + 1)
    
    for x in 1...sourceLength {
        
        distance[x, 0] = x
        
    }
    
    for y in 1...targetLength {
        
        distance[0, y] = y
        
    }
    
    for x in 1...sourceLength {
        
        for y in 1...targetLength {
            
            if source[x - 1] == target[y - 1] {
                
                // no difference
                distance[x, y] = distance[x - 1, y - 1]
                
            } else {
                
                distance[x, y] = min3(
                    
                    // deletions
                    a: distance[x - 1, y] + 1,
                    // insertions
                    b: distance[x, y - 1] + 1,
                    // substitutions
                    c: distance[x - 1, y - 1] + 1
                    
                )
                
            }
            
        }
        
    }
    
    return distance[source.count, target.count]
    
}
