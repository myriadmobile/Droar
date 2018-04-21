//
//  Swizzling.swift
//  Pods
//
//  Created by Nathan Jangula on 8/15/17.
//
//

import Foundation

public class Swizzler {
    // Selector must be @objc dynamic
    public static func swizzleInstanceSelector(instance: NSObject, origSelector: Selector, newSelector: Selector) {
        let aClass: AnyClass = object_getClass(instance)!
        
        let origMethod = class_getInstanceMethod(aClass, origSelector)!
        let newMethod = class_getInstanceMethod(aClass, newSelector)!
        
        method_exchangeImplementations(origMethod, newMethod)
    }
    
    // Selector must be @objc dynamic class
    public static func swizzleClassSelector(aClass: AnyClass, origSelector: Selector, newSelector: Selector) {
        let origMethod = class_getClassMethod(aClass, origSelector)!
        let newMethod = class_getClassMethod(aClass, newSelector)!
        
        method_exchangeImplementations(origMethod, newMethod)
    }
}

