//
//  FontExtensions.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

extension String: Error {}

internal extension UIFont {
    
    //Registration
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
    
    static func font(named: String, size: CGFloat, resource: String) -> UIFont? {
        //Get if the font exists
        if let font = UIFont(name: named, size: size) { return font }
        
        //Attempt register if it does not
        if let fontUrl = Bundle.podBundle.url(forResource: resource, withExtension: ".ttf") {
            do {
                try UIFont.register(url: fontUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        //Return new font if it exists
        return UIFont(name: named, size: size)
    }
    
    //Fonts
    static func russo(_ size: CGFloat) -> UIFont {
        let fontName = "Russo One"
        let resourceName = "RussoOne-Regular"
        
        return UIFont.font(named: fontName, size: size, resource: resourceName) ?? UIFont.systemFont(ofSize: size)
    }
    
}
