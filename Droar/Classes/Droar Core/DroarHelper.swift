//
//  DroarHelper.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

internal extension Droar {
    
    static func initializeWindow() {
        
        //Container - this holds the nav stack for Droar
        containerViewController = UIViewController()
        containerViewController.view.backgroundColor = UIColor.clear
        containerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //VC - this is the main screen for Droar
        viewController = DroarViewController(style: .grouped)
        
        //Nav - this is the nav stack for Droar
        navController = UINavigationController(rootViewController: viewController!)
        navController.view.frame = CGRect(x: containerViewController.view.frame.width, y: 0, width: drawerWidth, height: containerViewController.view.frame.height)
        navController.view.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        navController.navigationBar.isTranslucent = false
        navController.view.layer.borderWidth = 1
        navController.view.layer.borderColor = UIColor.droarBlue.cgColor
        
        //Build relationships
        #if swift(>=4.2)
        navController.willMove(toParent: viewController)
        containerViewController.addChild(navController)
        containerViewController.view.addSubview(navController.view)
        navController.didMove(toParent: containerViewController)
        #else
        navController.willMove(toParentViewController: viewController)
        containerViewController.addChildViewController(navController)
        containerViewController.view.addSubview(navController.view)
        navController.didMove(toParentViewController: containerViewController)
        #endif
        
        //This observer watches for when new windows become available; we need to move gesture recognizer to the new window when this happens
        #if swift(>=4.2)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: UIWindow.didBecomeKeyNotification, object: nil)
        #else
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: NSNotification.Name.UIWindowDidBecomeKey, object: nil)
        #endif
    }
    
    //Handlers
    @objc private static func handleReceivedWindowDidBecomeKeyNotification(notification: NSNotification) {
        if let window = notification.object as? UIWindow {
            window.addGestureRecognizer(gestureRecognizer)
        } else {
            loadKeyWindow()?.addGestureRecognizer(gestureRecognizer)
        }
    }
    
}
