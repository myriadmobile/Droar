//
//  DroarHelper.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

internal extension Droar {
    static func addDebugDrawer() {
        if let fontUrl = Bundle.podBundle.url(forResource: "RussoOne-Regular", withExtension: ".ttf") {
            do {
                try UIFont.register(url: fontUrl)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 3
        
        setGestureReconizer(value: tapRecognizer)
        
        dismissalRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(toggleVisibility))
        dismissalRecognizer?.direction = .right
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: NSNotification.Name.UIWindowDidBecomeKey, object: nil)
    }
    
    static func initializeWindow() {
        viewController = DroarViewController(style: .grouped)
        
        navController = UINavigationController(rootViewController: viewController!)
        navController.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: drawerWidth, height: UIScreen.main.bounds.size.height)
        navController.view.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
        navController.navigationBar.isTranslucent = false
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: navController.view.frame.size.height))
        separatorView.backgroundColor = UIColor.droarBlue
        separatorView.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        navController.view.addSubview(separatorView)
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
            if window.windowLevel != UIWindowLevelNormal {
                for otherWindow in UIApplication.shared.windows {
                    if otherWindow.windowLevel == UIWindowLevelNormal {
                        window = otherWindow
                        break
                    }
                }
            }
            
            for subview in window.subviews {
                var responder = subview.next
                //added this block of code for iOS 8 which puts a UITransitionView in between the UIWindow and the UILayoutContainerView
                if responder?.isEqual(window) ?? false {
                    //this is a UITransitionView
                    if subview.subviews.count > 0 {
                        let subSubView = subview.subviews.first
                        responder = subSubView?.next
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
        let parent = navController.view.superview
        navController.view.removeFromSuperview()
        
        guard let window = loadKeyWindow() else { return .none }
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return .none }
        window.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        parent?.addSubview(navController.view)
        
        return image
    }
    
    static func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
//        if let active = loadActiveResponder() as? UIViewController {
//            active.present(viewController, animated: true, completion: completion)
//        }

    navController.present(viewController, animated: animated, completion: completion)
    }
}
