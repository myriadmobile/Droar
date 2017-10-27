//
//  Droar.swift
//  Pods
//
//  Created by Nathan Jangula on 6/5/17.
//
//

import Foundation

@objc public enum DroarGestureType: UInt {
    case tripleTap
}

@objc public class Droar: NSObject {
    
    // Droar is a purely static class.
    private override init() { }
    
    internal static var gestureRecognizer: UIGestureRecognizer?
    internal static var dismissalRecognizer: UISwipeGestureRecognizer?
    internal static var navController: UINavigationController!
    internal static var viewController: DroarViewController?
    internal static let drawerWidth:CGFloat = 250
    private static let startOnce = DispatchOnce()
    
    @objc public static func start()
    {
        startOnce.perform {
            initializeWindow()
            setGestureType(.tripleTap)
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
    
    @objc public static func setGestureType(_ type: DroarGestureType) {
        configureRecognizerForType(type)
    }
    
    // For plugins
    @objc public static func pushViewController(_ viewController: UIViewController, animated: Bool) {
        navController.pushViewController(viewController, animated: animated)
    }
    
//    @objc public static func showWindow() {
//        // TODO
//    }
//
//    @objc public static func dismissWindow() {
//        // TODO
//    }
}
