//
//  RatingControl.swift
//  TestApp2
//
//  Created by Adam Moorey on 07/11/2016.
//  Copyright © 2016 Adam Moorey. All rights reserved.
//

import UIKit

class RatingControl: UIView
{
    // MARK: Properties
    
    var rating = 0
        {
        //observer updates layout whenever rating is changed
        //ensures accurate representation of rating
            didSet
            {
                setNeedsLayout()
            }
        }
    
    var ratingButtons = [UIButton]()
    let spacing = 5
    let starCount = 5
    
    // MARK: Initilisation
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        let emptyStarImage = UIImage(named: "emptyStar")
        let filledStarImage = UIImage(named: "filledStar")
        
        //generate five buttons, each stacked ontop of one another
        for _ in 0..<starCount
        {
            let button = UIButton()
            
            //sets the image of the button in various states:
            //normal - empty star; highlighted or selected - filled star
            button.setImage(emptyStarImage, for: .normal)
            button.setImage(filledStarImage, for: .selected)
            button.setImage(filledStarImage, for: [.highlighted, .selected])
            
            //makes sure when highlighted, during state change
            button.adjustsImageWhenHighlighted = false
            
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(_:)), for: .touchDown)
            ratingButtons += [button]
            addSubview(button)
        }
    }
    
    override func layoutSubviews()
    {
        //set the button's width and height to a square the size of the frame's height
        let buttonSize = Int(frame.size.height)
        
        var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        
        //offset each button's origin by the length of the button plus spacing
        for (index, button) in ratingButtons.enumerated()
        {
            buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
            button.frame = buttonFrame
        }
        
        updateButtonSelectionStates()
    }
    
    override public var intrinsicContentSize: CGSize
    {
        let buttonSize = Int(frame.size.height)
        let width = (buttonSize * starCount) + (spacing * (starCount - 1))
        
        return CGSize(width: width, height: buttonSize)
    }
    
    // MARK: Button Action
    public func ratingButtonTapped(_ button: UIButton!)
    {
        //searchs through array of buttons, to find this one and return int
        rating = ratingButtons.index(of: button)! + 1
        
        updateButtonSelectionStates()
    }
    
    func updateButtonSelectionStates()
    {
        //iterates through button array
        for (index, button) in ratingButtons.enumerated()
        {
            button.isSelected = index < rating
        }
    }
}
