//
//  BundleExtensions.swift
//  Droar
//
//  Created by Nathan Jangula on 10/11/17.
//

import Foundation

internal extension Bundle {
    static var podBundle: Bundle {
        get {
            var bundlePath = Bundle.main.path(forResource: "Droar", ofType: "bundle", inDirectory: "Frameworks/Droar.framework")
            
            if bundlePath == nil {
                bundlePath = Bundle.main.path(forResource: "Droar", ofType: "bundle")
            }
            
            return Bundle(path: bundlePath!)!
        }
    }
}
