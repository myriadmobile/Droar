//
//  DispatchOnce.swift
//  Droar
//
//  Created by Nathan Jangula on 10/13/17.
//

import Foundation

@objc public class DispatchOnce : NSObject {
    
    private var locked = false
        
    @objc public func perform(_ block: () -> Void) {
        if !locked {
            locked = true
            block()
        }
    }
}
