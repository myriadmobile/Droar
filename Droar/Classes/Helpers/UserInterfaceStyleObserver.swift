//
//  UserInterfaceStyleObserver.swift
//  Droar
//
//  Created by Feng Chang on 7/11/20.
//

import Foundation
import UIKit

@available(iOS 12.0, *)
public protocol UserInterfaceStyleObserver: class {
    func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager)
    func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle)
}


@available(iOS 12.0, *)
extension UIViewController: UserInterfaceStyleObserver {
    
    public func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view controller as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view controller to desire style when start observing
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
        }
    }
    
    public func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIViewController
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = style
        }
        
        // Update status bar style
        setNeedsStatusBarAppearanceUpdate()
    }
}

@available(iOS 12.0, *)
extension UIView: UserInterfaceStyleObserver {
    
    public func startObserving(_ userInterfaceStyleManager: inout UserInterfaceStyleManager) {
        // Add view as observer of UserInterfaceStyleManager
        userInterfaceStyleManager.addObserver(self)
        
        // Change view to desire style when start observing
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = userInterfaceStyleManager.currentStyle
        }
    }
    
    public func userInterfaceStyleManager(_ manager: UserInterfaceStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIView
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = style
        }
    }
}
