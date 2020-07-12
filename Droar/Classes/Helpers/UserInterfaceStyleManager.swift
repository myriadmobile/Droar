//
//  UserInterfaceStyleManager.swift
//  Droar
//
//  Created by Feng Chang on 7/11/20.
//

import UIKit

@available(iOS 12.0, *)
public struct UserInterfaceStyleManager {
    
    static let userInterfaceStyleDarkModeOn = "userInterfaceStyleDarkModeOn";
    
    public static var shared = UserInterfaceStyleManager()
    private var observers = [ObjectIdentifier : WeakStyleObserver]()
    
    private init() { }
    
    private(set) var currentStyle: UIUserInterfaceStyle = UserDefaults.standard.bool(forKey: UserInterfaceStyleManager.userInterfaceStyleDarkModeOn) ? .dark : .light {
        // Property observer to trigger every time value is set to currentStyle
        didSet {
            if currentStyle != oldValue {
                // Trigger notification when currentStyle value changed
                styleDidChanged()
            }
        }
    }
}

// MARK:- Public functions
@available(iOS 12.0, *)
extension UserInterfaceStyleManager {
    
    mutating func addObserver(_ observer: UserInterfaceStyleObserver) {
        let id = ObjectIdentifier(observer)
        // Create a weak reference observer and add to dictionary
        observers[id] = WeakStyleObserver(observer: observer)
    }
    
    mutating func removeObserver(_ observer: UserInterfaceStyleObserver) {
        let id = ObjectIdentifier(observer)
        observers.removeValue(forKey: id)
    }
    
    mutating func updateUserInterfaceStyle(_ isDarkMode: Bool) {
        currentStyle = isDarkMode ? .dark : .light
    }
}

// MARK:- Private functions
@available(iOS 12.0, *)
private extension UserInterfaceStyleManager {
    mutating func styleDidChanged() {
        for (id, weakObserver) in observers {
            // Clean up observer that no longer in memory
            guard let observer = weakObserver.observer else {
                observers.removeValue(forKey: id)
                continue
            }
            
            // Notify observer by triggering userInterfaceStyleManager(_:didChangeStyle:)
            observer.userInterfaceStyleManager(self, didChangeStyle: currentStyle)
        }
    }
}
