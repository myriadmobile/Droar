//
//  Droar.swift
//  Pods
//
//  Created by Nathan Jangula on 6/5/17.
//
//

import Foundation

@objc public class Droar: NSObject {
    
    // Droar is a purely static class.
    private override init() { }
    
    private static var gestureRecognizer: UIGestureRecognizer?
    private static var dismissalRecognizer: UISwipeGestureRecognizer?
    internal static var navController: UINavigationController!
    private static var viewController: DroarViewController?
    private static let drawerWidth:CGFloat = 250
    
    @objc public static func start()
    {
        addDebugDrawer()
        initializeWindow()
    }
    
    public func registerSource(source: ISectionSource) {
        SectionManager.sharedInstance.registerSource(source: source)
        Droar.viewController?.tableView.reloadData()
    }
    
    private static func allowEnable() -> Bool
    {
        var isDebug = false
        
        #if DEBUG
            isDebug = true
        #endif
        
        return isDebug || TestflightDetection.isTestflightBuild()
    }
    
    static var firstAdd = true
    
    private static func addDebugDrawer()
    {
        if !allowEnable() { return }
        if !firstAdd { return }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 3
        
        setGestureReconizer(value: tapRecognizer)
        
        dismissalRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(toggleVisibility))
        dismissalRecognizer?.direction = .right
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: NSNotification.Name.UIWindowDidBecomeKey, object: nil)
        
        firstAdd = false
    }
    
    @objc public static func setGestureReconizer(value: UIGestureRecognizer)
    {
        if allowEnable() {
            if let recognizer = gestureRecognizer {
                recognizer.view?.removeGestureRecognizer(recognizer)
            }
            
            gestureRecognizer = value
            
            if let recognizer = gestureRecognizer {
                recognizer.addTarget(self, action: #selector(toggleVisibility))
                loadKeyWindow()?.addGestureRecognizer(recognizer)
            }
        }
    }
    
    @objc public static func toggleVisibility() {
        if let visibleView = getVisibleView() {
            if Droar.navController?.view.transform.isIdentity ?? false {
                Droar.navController?.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: drawerWidth, height: UIScreen.main.bounds.size.height)
                
                visibleView.addSubview(Droar.navController.view)
                //            [[FactoryManager sharedInstance] setObservers:[self getCurrentObserversFromViewController:visibleViewController]];
                
                Droar.viewController?.tableView.reloadData()
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                if navController.view.transform.isIdentity {
                    navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
                    
                    if let recognizer = gestureRecognizer {
                        visibleView.removeGestureRecognizer(recognizer)
                    }
                    
                    visibleView.addGestureRecognizer(dismissalRecognizer!)
                } else {
                    navController.view.transform = CGAffineTransform.identity
                    visibleView.removeGestureRecognizer(dismissalRecognizer!)
                    if let recognizer = gestureRecognizer {
                        visibleView .addGestureRecognizer(recognizer)
                    }
                }
            }, completion: { (complete) in
                if navController.view.transform.isIdentity {
                    navController.view.removeFromSuperview()
                }
            })
        }
    }
    
    
    private static func getVisibleView() -> UIView? {
        var window = UIApplication.shared.keyWindow
        
        if (window == nil) {
            window = UIApplication.shared.delegate?.window!
        }
        
        return window
    }
    
    @objc private static func handleReceivedWindowDidBecomeKeyNotification(notification:NSNotification) {
        if let recognizer = gestureRecognizer {
            
            recognizer.view?.removeGestureRecognizer(recognizer)
            
            if let window = notification.object as? UIWindow {
                window.addGestureRecognizer(recognizer)
            } else {
                loadKeyWindow()?.addGestureRecognizer(recognizer)
            }
        }
    }
    
    private static func loadKeyWindow() -> UIWindow? {
        var window = UIApplication.shared.keyWindow
        
        if window == nil {
            window = UIApplication.shared.delegate?.window ?? nil
        }
        
        return window
    }
    
    private static func initializeWindow() {
        viewController = DroarViewController(style: .grouped)
        
        navController = UINavigationController(rootViewController: viewController!)
        navController.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: drawerWidth, height: UIScreen.main.bounds.size.height)
        navController.view.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        navController.navigationBar.isTranslucent = false
        
        let separatorView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: navController.view.frame.size.height))
        separatorView.backgroundColor = UIColor.black
        separatorView.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        navController.view.addSubview(separatorView)
    }
}
