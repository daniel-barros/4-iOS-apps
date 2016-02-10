//
//  PatternView.swift
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

/// A view with 9 subviews. Highlights touched subviews until the user lifts his finger, then all subviews get normal color. Notifies its delegate of these events.
class BoardView: UIView, UITableViewDelegate {
    
    static let regularSquareColor = UIColor(white: 0.9, alpha: 1)
    static let selectedSquareColor = UIColor.blueColor()
    
    private var elementWidth: CGFloat { return frame.width * 0.3 }
    private var width: CGFloat { return frame.width }
    private var elementMargin: CGFloat { return elementWidth * 0.2 }
    // Positions of recognizable pattern elements (similar to corresponding subviews positions, but with some margins)
    // first is position of left side of first element, second is the right side, third is left side of second element, etc. This is a square board so it applies both for x and y axis
    private var first: CGFloat { return 10 + elementMargin }
    private var second: CGFloat { return elementWidth + 20 - elementMargin }
    private var third: CGFloat { return width / 2 - elementWidth / 2 + elementMargin }
    private var fourth: CGFloat { return width / 2 + elementWidth / 2 - elementMargin }
    private var fifth: CGFloat { return width - elementWidth - 20 + elementMargin }
    private var sixth: CGFloat { return width - 10 - elementMargin }
    
    weak var delegate: BoardViewDelegate?
    
    override private init(frame: CGRect) {
        fatalError("init(frame:) not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        subviews.forEach {
            $0.layer.cornerRadius = $0.bounds.height / 2
            $0.backgroundColor = BoardView.regularSquareColor
        }
    }
    
    /// Fills the selected cells with a color for a moment, then goes back to regular color
    func fillElementsWithColor(color: UIColor, elements: [Int]) {
        UIView.animateWithDuration(0.3, animations: {
            elements.forEach {
                self.subviews[$0].backgroundColor = color
            }
            }, completion: { completed in
                UIView.animateWithDuration(0.3) {
                    self.subviews.forEach {
                        $0.backgroundColor = BoardView.regularSquareColor
                    }
                }
        })
    }
    
    // MARK: Touches
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate?.boardViewFingerDown(self)
        handleSquareViewTouched(touches)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        handleSquareViewTouched(touches)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        fingerUp()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        fingerUp()
    }
    
    // MARK: Help functions
    
    /// Highlights the selected subview and notifies the delegate
    private func handleSquareViewTouched(touches: Set<UITouch>) {
        let location = touches.first!.locationInView(self)
        if let squareView = subviewFromLocation(location) {
            squareView.backgroundColor = BoardView.selectedSquareColor
            delegate?.boardViewSquareTouched(self, index: subviews.indexOf(squareView)!)
        }
    }
    
    /// Returns the subview which contains the given location
    private func subviewFromLocation(location: CGPoint) -> UIView? {
        switch (location.x, location.y) {
        case (first...second, first...second):
            return subviews[0]
        case (third...fourth, first...second):
            return subviews[1]
        case (fifth...sixth, first...second):
            return subviews[2]
        case (first...second, third...fourth):
            return subviews[3]
        case (third...fourth, third...fourth):
            return subviews[4]
        case (fifth...sixth, third...fourth):
            return subviews[5]
        case (first...second, fifth...sixth):
            return subviews[6]
        case (third...fourth, fifth...sixth):
            return subviews[7]
        case (fifth...sixth, fifth...sixth):
            return subviews[8]
        default:
            return nil
        }
    }
    
    /// Turns highlighted subviews back to normal color and notifies delegate
    private func fingerUp() {
        subviews.forEach {
            $0.backgroundColor = BoardView.regularSquareColor
        }
        delegate?.boardViewFingerUp(self)
    }
}


protocol BoardViewDelegate: class {
    func boardViewFingerDown(boardView: BoardView)
    func boardViewSquareTouched(boardView: BoardView, index: Int)   // index is the index of the square view touched
    func boardViewFingerUp(boardView: BoardView)
}
