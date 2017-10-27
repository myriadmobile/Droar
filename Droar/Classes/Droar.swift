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
    
    internal static var gestureRecognizer: UIGestureRecognizer?
    internal static var dismissalRecognizer: UISwipeGestureRecognizer?
    internal static var navController: UINavigationController!
    internal static var viewController: DroarViewController?
    internal static let drawerWidth:CGFloat = 250
    internal static let startOnce = DispatchOnce()
    
    @objc public static func start()
    {
        startOnce.perform {
            addDebugDrawer()
            initializeWindow()
        }
    }
    
    @objc public static func register(_ knob: DroarKnob) {
        KnobManager.sharedInstance.registerStaticKnob(knob)
        viewController?.tableView.reloadData()
    }
    
    @objc(registerDefaultKnobs:)
    public static func objc_registerDefaultKnobs(knobs: [Int]) {
        registerDefaultKnobs(knobs.map({ DefaultKnobType(rawValue: $0)! }))
    }
    
    public static func registerDefaultKnobs(_ knobs: [DefaultKnobType]) {
        KnobManager.sharedInstance.registerDefaultKnobs(knobs)
        viewController?.tableView.reloadData()
    }
    
    @objc public static func setGestureReconizer(value: UIGestureRecognizer) {
        if let recognizer = gestureRecognizer {
            recognizer.view?.removeGestureRecognizer(recognizer)
        }
        
        gestureRecognizer = value
        
        if let recognizer = gestureRecognizer {
            recognizer.addTarget(self, action: #selector(toggleVisibility))
            loadKeyWindow()?.addGestureRecognizer(recognizer)
        }
    }
    
    @objc public static func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navController.pushViewController(viewController, animated: animated)
    }
    
    @objc public static func toggleVisibility() {        
        if let keyWindow = loadKeyWindow(), let activeVC = loadActiveResponder() as? UIViewController {
            if navController?.view.transform.isIdentity ?? false {
                KnobManager.sharedInstance.registerDynamicKnobs(loadDynamicKnobs())
                KnobManager.sharedInstance.prepareForDisplay(tableView: viewController?.tableView)
                
                navController?.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: drawerWidth, height: UIScreen.main.bounds.size.height)
                navController.willMove(toParentViewController: activeVC)
                activeVC.addChildViewController(navController)
                activeVC.view.addSubview(navController.view)
                navController.didMove(toParentViewController: activeVC)
                
                viewController?.tableView.reloadData()
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
                    navController.willMove(toParentViewController: nil)
                    navController.view.removeFromSuperview()
                    navController.removeFromParentViewController()
                }
            })
        }
    }
}
