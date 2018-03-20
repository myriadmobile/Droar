//
//  NSAttributedStringKeyExtension.swift
//  Droar
//
//  Created by Nathan Jangula on 10/27/17.
//

import Foundation

#if !swift(>=4.0)
internal extension NSAttributedStringKey {
    public class var foregroundColor: String {
        return NSForegroundColorAttributeName
    }
    
    public class var font: String {
        return NSFontAttributeName
    }
    }
#endif
