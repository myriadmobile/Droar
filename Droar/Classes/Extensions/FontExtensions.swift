//
//  FontExtensions.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

extension String: Error {}

public extension UIFont {
    public static func register(url: URL) throws {
        guard let fontDataProvider = CGDataProvider(url: url as CFURL) else {
            throw "Could not create font data provider for \(url)."
        }
        guard let font = CGFont(fontDataProvider) else {
            throw "Could not create font for \(url)."
        }
        var error: Unmanaged<CFError>?
        guard CTFontManagerRegisterGraphicsFont(font, &error) else {
            throw error!.takeUnretainedValue()
        }
    }
}
