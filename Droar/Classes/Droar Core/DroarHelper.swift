//
//  DroarHelper.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

class DroarWindow: UIWindow {
    
    internal let defaultContainerAlpha: CGFloat = 0.5
    
    func setActivationPercent(_ percent: CGFloat) {
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: defaultContainerAlpha * percent)
    }
    
}

internal extension Droar {
    
    static func initializeWindow() {
        
        //Window - we must add Droar to a high level window to keep it always on top
        window = DroarWindow.init(frame: UIScreen.main.bounds)
        window.backgroundColor = .clear
        window.windowLevel = .init(.greatestFiniteMagnitude) //Topmost
        window.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //VC - this is the main screen for Droar
        viewController = DroarViewController(style: .grouped)
        
        //Nav - this is the nav stack for Droar
        navController = UINavigationController(rootViewController: viewController!)
        navController.view.frame = CGRect(x: window.frame.width, y: 0, width: drawerWidth, height: window.frame.height)
        navController.view.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        navController.navigationBar.isTranslucent = false
        navController.view.layer.borderWidth = 1
        navController.view.layer.borderColor = UIColor.droarBlue.cgColor
        
        //This observer watches for when new windows become available; we need to move gesture recognizer to the new window when this happens
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: UIWindow.didBecomeKeyNotification, object: nil)
    }
    
    //Handlers
    @objc private static func handleReceivedWindowDidBecomeKeyNotification(notification: NSNotification) {
        if let window = notification.object as? UIWindow {
            window.addGestureRecognizer(openRecognizer)
        } else {
            loadKeyWindow()?.addGestureRecognizer(openRecognizer)
        }
    }
    
}
