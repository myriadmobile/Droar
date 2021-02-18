//
//  UIViewControllerExtensions.swift
//  Droar
//
//  Created by Nathan Jangula on 10/16/17.
//

import Foundation

internal extension UIViewController {
    func loadActiveViewControllers() -> [UIViewController] {
        if let presentedVC = presentedViewController, !presentedViewController!.isBeingDismissed {
            return presentedVC.loadActiveViewControllers()
        }
        
        if let navTopVC = (self as? UINavigationController)?.topViewController {
            var viewControllers = [self]
            viewControllers.append(contentsOf: navTopVC.loadActiveViewControllers())
            return viewControllers
        }
        
        if let tabBarVC = (self as? UITabBarController)?.selectedViewController {
            var viewControllers = [self]
            viewControllers.append(contentsOf: tabBarVC.loadActiveViewControllers())
            return viewControllers
        }
        
        if let splitVCs = (self as? UISplitViewController)?.viewControllers {
            var viewControllers = [self]
            for viewController in splitVCs {
                viewControllers.append(contentsOf: viewController.loadActiveViewControllers())
            }
            return viewControllers
        }
        
        var viewControllers: [UIViewController] = [self]
        viewControllers.append(contentsOf: children)
        return viewControllers
    }
}
