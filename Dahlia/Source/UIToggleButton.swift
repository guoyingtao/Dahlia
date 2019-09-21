//
//  UIToggleButton.swift
//  Toggle buttons and switches
//
//
//  An exercise file for iOS Development Tips Weekly
//  by Steven Lipton (C)2018, All rights reserved
//  For videos go to http://bit.ly/TipsLinkedInLearning
//  For code go to http://bit.ly/AppPieGithub
//

import UIKit

class UIToggleButton: UIButton {

    var isOn: Bool = false {
        didSet{
            updateDisplay()
        }
    }
    
    var onImage: UIImage! = nil {
        didSet{
            updateDisplay()
        }
    }
    
    var offImage:UIImage! = nil {
        didSet{
            updateDisplay()
        }
    }
     
    func updateDisplay(){
        if isOn {
            if let onImage = onImage {
                let tintedImage = onImage.withRenderingMode(.alwaysTemplate)
                setImage(tintedImage, for: .normal)
                tintColor = .white
            }
        } else {
            if let offImage = offImage {
                let tintedImage = offImage.withRenderingMode(.alwaysTemplate)
                setImage(tintedImage, for: .normal)
                tintColor = .lightGray
            }
        }
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        isOn = !isOn
    }
}
