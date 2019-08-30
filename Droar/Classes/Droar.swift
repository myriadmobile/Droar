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
    
    internal static var gestureRecognizer: UIGestureRecognizer!
    internal static var dismissalRecognizer: UISwipeGestureRecognizer!
    internal static var containerViewController: UIViewController!
    internal static let defaultContainerAlpha: CGFloat = 0.5
    internal static var navController: UINavigationController!
    internal static var viewController: DroarViewController?
    internal static let drawerWidth:CGFloat = 300
    private static let startOnce = DispatchOnce()
    public static private(set) var isStarted = false;
    
    @objc public static func start()
    {
        startOnce.perform {
            initializeWindow()
            setGestureType(.panFromRight)
            KnobManager.sharedInstance.prepareForStart()
            Droar.isStarted = true
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
    
    @objc public static func setGestureType(_ type: DroarGestureType, _ threshold: CGFloat = 50.0) {
        configureRecognizerForType(type, threshold)
    }
    
    // For plugins
    @objc public static func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navController.pushViewController(viewController, animated: animated)
    }
    
}

//Visibility
extension Droar {
    
    //Technically this could be wrong depending on the tx value, but it is close enough.
    @objc public static var isVisible: Bool { return !(navController.view.transform == CGAffineTransform.identity) }
    
    @objc public static func openDroar(completion: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
            setContainerOpacity(1)
        }) { (completed) in
            endDroarVisibilityUpdate(completion)
        }
    }
    
    @objc public static func closeDroar(completion: (()->Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: {
            navController.view.transform = CGAffineTransform.identity
            setContainerOpacity(0)
        }) { (completed) in
            endDroarVisibilityUpdate(completion)
        }
    }
    
    @objc static func toggleVisibility(completion: (()->Void)? = nil) {
        if isVisible {
            closeDroar(completion: completion)
        } else {
            openDroar(completion: completion)
        }
    }
    
    private static func setContainerOpacity(_ opacity: CGFloat) {
        containerViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: defaultContainerAlpha * opacity)
    }
    
}
