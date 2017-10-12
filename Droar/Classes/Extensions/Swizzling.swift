//
//  Swizzling.swift
//  Pods
//
//  Created by Nathan Jangula on 8/15/17.
//
//

import Foundation

public class DispatchOnce {
    
    private var locked = false
    
    public func perform(block: () -> Void) {
        if !locked {
            locked = true
            block()
        }
    }
}

public extension NSObject {
    public class func swizzleImplementations(origSelector: Selector, withSelector: Selector, once:DispatchOnce) {
        let aClass: AnyClass = object_getClass(self)!
        
        let origMethod = class_getClassMethod(aClass, origSelector)!
        let withMethod = class_getClassMethod(aClass, withSelector)!
        
        swizzleImplementations(aClass: aClass, origSelector: origSelector, withSelector: withSelector, origMethod: origMethod, withMethod: withMethod, once: once)
    }
    
    public func swizzleImplementations(origSelector: Selector, withSelector: Selector, once:DispatchOnce) {
        
        let aClass: AnyClass = object_getClass(self)!
        
        let origMethod = class_getInstanceMethod(aClass, origSelector)!
        let withMethod = class_getInstanceMethod(aClass, withSelector)!
        
        NSObject.swizzleImplementations(aClass: aClass, origSelector: origSelector, withSelector: withSelector, origMethod: origMethod, withMethod: withMethod, once: once)
    }
    
    private class func swizzleImplementations(aClass: AnyClass, origSelector: Selector, withSelector: Selector, origMethod: Method, withMethod: Method, once:DispatchOnce) {
        once.perform {
            let didAddMethod = class_addMethod(aClass, origSelector, method_getImplementation(withMethod), method_getTypeEncoding(withMethod))
            
            if didAddMethod {
                class_replaceMethod(aClass, withSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
            }
            else
            {
                method_exchangeImplementations(origMethod, withMethod)
            }
        }
    }
}
