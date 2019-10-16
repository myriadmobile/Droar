//
//  BundleExtensions.swift
//  Droar
//
//  Created by Nathan Jangula on 10/11/17.
//

import Foundation

internal extension Bundle {
    
    static var podBundle: Bundle {
        return Bundle(for: Droar.self)
    }
    
}
