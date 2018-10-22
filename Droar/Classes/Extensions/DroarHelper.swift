//
//  DroarHelper.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

internal extension Droar {
    static func initializeWindow() {
        let size = UIScreen.main.bounds.size
        containerViewController = UIViewController()
        containerViewController.view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        containerViewController.view.backgroundColor = UIColor.clear
        containerViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController = DroarViewController(style: .grouped)
        
        navController = UINavigationController(rootViewController: viewController!)
        navController.view.frame = CGRect(x: size.width, y: 0, width: drawerWidth, height: size.height)
        navController.view.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        navController.navigationBar.isTranslucent = false
        
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
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: navController.view.frame.size.height))
        separatorView.backgroundColor = UIColor.droarBlue
        separatorView.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        navController.view.addSubview(separatorView)
        
        #if swift(>=4.2)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: UIWindow.didBecomeKeyNotification, object: nil)
        #else
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: NSNotification.Name.UIWindowDidBecomeKey, object: nil)
        #endif
        
        if let fontUrl = Bundle.podBundle.url(forResource: "RussoOne-Regular", withExtension: ".ttf") {
            do {
                try UIFont.register(url: fontUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        dismissalRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissWindow))
        dismissalRecognizer.direction = .right
    }
    
    @objc private static func dismissWindow() {
        if Droar.isVisible {
            toggleVisibility(nil)
        }
    }
    
    static func loadDynamicKnobs() -> [DroarKnob] {
        if let activeVC = loadActiveResponder() as? UIViewController {
            
            let candidateVCs = activeVC.loadActiveViewControllers()
            var knobs = [DroarKnob]()
            
            for candidate in candidateVCs {
                if candidate is DroarKnob {
                    knobs.append(candidate as! DroarKnob)
                }
            }
            
            return knobs
        }
        
        return []
    }
    
    @objc static func handleReceivedWindowDidBecomeKeyNotification(notification:NSNotification) {
        if let recognizer = gestureRecognizer {
            recognizer.view?.removeGestureRecognizer(recognizer)
            
            if let window = notification.object as? UIWindow {
                window.addGestureRecognizer(recognizer)
            } else {
                loadKeyWindow()?.addGestureRecognizer(recognizer)
            }
        }
    }
    
    static func loadActiveResponder() -> UIResponder? {
        if var window = loadKeyWindow() {
            #if swift(>=4.2)
            if window.windowLevel != UIWindow.Level.normal {
                for otherWindow in UIApplication.shared.windows {
                    if otherWindow.windowLevel == UIWindow.Level.normal {
                        window = otherWindow
                        break
                    }
                }
            }
            #else
            if window.windowLevel != UIWindowLevelNormal {
                for otherWindow in UIApplication.shared.windows {
                    if otherWindow.windowLevel == UIWindowLevelNormal {
                        window = otherWindow
                        break
                    }
                }
            }
            #endif
            
            for subview in window.subviews {
                var responder = subview.next
                //added this block of code for iOS 8 which puts a UITransitionView in between the UIWindow and the UILayoutContainerView
                if responder?.isEqual(window) ?? false {
                    //this is a UITransitionView
                    if subview.subviews.count > 0 {
                        let subSubView = subview.subviews.first
                        responder = subSubView?.next
                    } else {
                        continue
                    }
                }
                
                return responder
            }
        }
        
        return nil
    }
    
    static func loadKeyWindow() -> UIWindow? {
        var window = UIApplication.shared.keyWindow
        
        if window == nil {
            window = UIApplication.shared.delegate?.window!
        }
        
        return window
    }
    
    static func captureScreen() -> UIImage? {
        let parent = containerViewController.view.superview
        containerViewController.view.removeFromSuperview()
        
        guard let window = loadKeyWindow() else { return .none }
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return .none }
        window.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        parent?.addSubview(containerViewController.view)
        
        return image
    }
    
    static func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navController.present(viewController, animated: animated, completion: completion)
    }
}
