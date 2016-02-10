//
//  PatternViewController.swift
//  appGestosFoto
//
//  Created by Daniel Barros López and Yoji Sargent Harada
//  Last modification on Feb 10 2016
//
//  Copyright (C) 2015  Yoji Sargent Harada, Daniel Barros López
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//


import UIKit

// Handles pattern recognition logic, manages a BoardView which handles pattern input and UI
class PatternViewController: UIViewController, BoardViewDelegate {
    
    var savedPatternIndexes: [Int] = [] // Elements are indexes of subviews
    var currentPatternIndexes: [Int] = []
    var savingPattern = true
    let minNumberOfElementsInPattern = 3

    @IBOutlet weak var boardView: BoardView! {
        didSet { boardView.delegate = self }
    }
    
    @IBOutlet var squareViews: [UIView]!
    
    weak var delegate: PatternViewDelegate?
    
    func startSavingNewPattern() {
        savingPattern = true
    }
    
    /// Gives feedback to user showing selected pattern in green
    func showGoodPattern(pattern: [Int]) {
        boardView.fillElementsWithColor(UIColor.greenColor(), elements: pattern)
    }
    
    /// Gives feedback to user showing selected pattern in red
    func showBadPattern(pattern: [Int]) {
        boardView.fillElementsWithColor(UIColor.redColor(), elements: pattern)
    }
    
    // MARK: BoardViewDelegate
    
    func boardViewSquareTouched(boardView: BoardView, index: Int) {
        if !currentPatternIndexes.contains(index) {
            currentPatternIndexes.append(index)
        }
    }
    
    func boardViewFingerUp(boardView: BoardView) {
        if savingPattern {
            if currentPatternIndexes.count >= minNumberOfElementsInPattern {    // New pattern set
                savedPatternIndexes = currentPatternIndexes
                savingPattern = false
                showGoodPattern(currentPatternIndexes)
                delegate?.didSaveNewPattern()
            } else {    // Bad pattern not set
                
            }
        } else {
            if currentPatternIndexes == savedPatternIndexes {   // Pattern match
                showGoodPattern(currentPatternIndexes)
                delegate?.didMatchPattern()
            } else {    // Wrong pattern
                showBadPattern(currentPatternIndexes)
            }
        }
    }
    
    func boardViewFingerDown(boardView: BoardView) {
        currentPatternIndexes = []  // Reset pattern
    }
}

protocol PatternViewDelegate: class {
    func didSaveNewPattern()
    func didMatchPattern()
}
