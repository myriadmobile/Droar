//
//  RoundedCornerView.swift
//  Droar_Example
//
//  Created by Feng Chang on 7/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Droar

class RoundedCornerView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .lightGray {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.5 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Observe user interface style change
        if #available(iOS 12.0, *) {
            startObserving(&UserInterfaceStyleManager.shared)
        }
        
        // Set corner radius
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
    
}
