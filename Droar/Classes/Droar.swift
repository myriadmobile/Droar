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
    
    private static let startOnce = DispatchOnce()
    
    @objc public static func start()
    {
        startOnce.perform {
            addDebugDrawer()
            initializeWindow()
        }
    }
    
    @objc public static func register(source: IDroarSource) {
        SectionManager.sharedInstance.registerStaticSource(source)
        Droar.viewController?.tableView.reloadData()
    }
    
    public static func registerBasicSources(_ sources: [BasicSourceType]) {
        SectionManager.sharedInstance.registerBasicSources(sources)
        Droar.viewController?.tableView.reloadData()
    }
    
    private static func allowEnable() -> Bool
    {
        var isDebug = false
        
        #if DEBUG
            isDebug = true
        #endif
        
        return isDebug || SourceDetection.isTestflightBuild()
    }
    
    
    private static func addDebugDrawer() {
        guard allowEnable() else { return }
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 3
        
        setGestureReconizer(value: tapRecognizer)
        
        dismissalRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(toggleVisibility))
        dismissalRecognizer?.direction = .right
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleReceivedWindowDidBecomeKeyNotification), name: NSNotification.Name.UIWindowDidBecomeKey, object: nil)
    }
    
    @objc public static func setGestureReconizer(value: UIGestureRecognizer) {
        guard allowEnable() else {return}
        
        if let recognizer = gestureRecognizer {
            recognizer.view?.removeGestureRecognizer(recognizer)
        }
        
        gestureRecognizer = value
        
        if let recognizer = gestureRecognizer {
            recognizer.addTarget(self, action: #selector(toggleVisibility))
            loadKeyWindow()?.addGestureRecognizer(recognizer)
        }
    }
    
    @objc public static func toggleVisibility() {
        if let keyWindow = loadKeyWindow() {
            if Droar.navController?.view.transform.isIdentity ?? false {
                Droar.navController?.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: drawerWidth, height: UIScreen.main.bounds.size.height)
                
                keyWindow.addSubview(Droar.navController.view)
                SectionManager.sharedInstance.registerDynamicSources(loadDynamicSources())
                
                Droar.viewController?.tableView.reloadData()
            }
            
            UIView.animate(withDuration: 0.25, animations: {
                if navController.view.transform.isIdentity {
                    navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
                    
                    if let recognizer = gestureRecognizer {
                        keyWindow.removeGestureRecognizer(recognizer)
                    }
                    
                    keyWindow.addGestureRecognizer(dismissalRecognizer!)
                } else {
                    navController.view.transform = CGAffineTransform.identity
                    keyWindow.removeGestureRecognizer(dismissalRecognizer!)
                    if let recognizer = gestureRecognizer {
                        keyWindow .addGestureRecognizer(recognizer)
                    }
                }
            }, completion: { (complete) in
                if navController.view.transform.isIdentity {
                    navController.view.removeFromSuperview()
                }
            })
        }
    }
    
    private static func loadDynamicSources() -> [IDroarSource] {
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
                
                if responder is UIViewController {
                    let responderVC = responder as! UIViewController
                    
                    let candidateVCs = responderVC.loadActiveViewControllers()
                    var sources = [IDroarSource]()
                    
                    for candidate in candidateVCs {
                        if candidate is IDroarSource {
                            sources.append(candidate as! IDroarSource)
                        }
                    }
                    
                    return sources
                }
            }
        }
        
        return []
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
            window = UIApplication.shared.delegate?.window!
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
