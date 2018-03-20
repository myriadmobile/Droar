//
//  FontExtensions.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

extension String: Error {}

internal extension UIFont {
    static func register(url: URL) throws {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            throw "Could not create font data provider for \(url)."
        }
        #if swift(>=4.0)
            guard let font = CGFont(fontDataProvider) else {
                throw "Could not create font for \(url)."
            }
        #else
            let font = CGFont(fontDataProvider)
        #endif
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            throw error!.takeUnretainedValue()
        }
    }
}
