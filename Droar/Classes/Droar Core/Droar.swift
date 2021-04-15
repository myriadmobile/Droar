//
//  Droar.swift
//  Pods
//
//  Created by Nathan Jangula on 6/5/17.
//
//

import UIKit

@objc public enum DroarGestureType: UInt {
    case tripleTap, panFromRight
}

@objc public class Droar: NSObject {
    
    // Droar is a purely static class.
    private override init() { }
    
    static var window: DroarWindow!
    
    internal static var navController: UINavigationController!
    internal static var viewController: DroarViewController?
    internal static let drawerWidth: CGFloat = 300
    private static let startOnce = DispatchOnce()
    public static private(set) var isStarted = false;
    
    @objc public static func start() {
        startOnce.perform {
            initializeWindow()
            setGestureType(.panFromRight)
            KnobManager.sharedInstance.prepareForStart()
            Droar.isStarted = true
        }
    }
    
    @objc public static func setGestureType(_ type: DroarGestureType, _ threshold: CGFloat = 50.0) {
        configureRecognizerForType(type, threshold)
    }
    
    //Navigation
    @objc public static func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navController.pushViewController(viewController, animated: animated)
    }
    
    @objc public static func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navController.present(viewController, animated: animated, completion: completion)
    }
    
    //Internal Accessors
    static func loadKeyWindow() -> UIWindow? {
        var window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        
        if window == nil {
            window = UIApplication.shared.keyWindow
        }
        
        return window
    }
    
    static func loadActiveResponder() -> UIViewController? {
        return loadKeyWindow()?.rootViewController
    }
    
}

//Knobs
extension Droar {
    
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
    
    public static func refreshKnobs() {
        viewController?.tableView.reloadData()
    }
    
}

//Visibility
extension Droar {
    
    //Technically this could be wrong depending on the tx value, but it is close enough.
    @objc public static var isVisible: Bool { return !(navController.view.transform == CGAffineTransform.identity) }
    
    @objc public static func openDroar(completion: (()->Void)? = nil) {
        window.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: {
            navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
            window.setActivationPercent(1)
        }) { (completed) in
            //Swap gestures
            openRecognizer.view?.removeGestureRecognizer(openRecognizer)
            window.addGestureRecognizer(dismissalRecognizer)
            
            completion?()
        }
    }
    
    @objc public static func closeDroar(completion: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            navController.view.transform = CGAffineTransform.identity
            window.setActivationPercent(0)
        }) { (completed) in
            window.isHidden = true
            
            //Swap gestures
            dismissalRecognizer.view?.removeGestureRecognizer(dismissalRecognizer)
            replaceGestureRecognizer(with: openRecognizer)
            
            completion?()
        }
    }
    
    @objc static func toggleVisibility(completion: (()->Void)? = nil) {
        if isVisible {
            closeDroar(completion: completion)
        } else {
            openDroar(completion: completion)
        }
    }
    
}

//Backwards compatibility
extension Droar {
    
    public static func dismissWindow() {
        closeDroar(completion: nil)
    }
    
}
