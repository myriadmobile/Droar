//
//  DroarGestureHandler.swift
//  Droar
//
//  Created by Nathan Jangula on 10/27/17.
//

import Foundation

internal extension Droar {
    static var threshold: CGFloat!
    private static let gestureDelegate = GestureDelegate()
    
    static func configureRecognizerForType(_ type: DroarGestureType, _ threshold: CGFloat) {
        self.threshold = threshold
        
        switch type {
        case .tripleTap:
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap(sender:)))
            recognizer.numberOfTapsRequired = 3
            recognizer.delegate = gestureDelegate
            replaceGestureRecognizer(with: recognizer)
            
        case .panFromRight:
            let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
            recognizer.delegate = gestureDelegate
            replaceGestureRecognizer(with: recognizer)
        }
    }
    
    @objc private static func handleTripleTap(sender: UITapGestureRecognizer?) {
        toggleVisibility(nil)
    }
    
    @objc private static func handlePan(sender: UIPanGestureRecognizer?) {
        if let sender = sender {
            switch sender.state {
            case .began:
                
                let distanceFromEdge = sender.view!.bounds.width - sender.location(in: sender.view).x
                // Make sure they started on the far edge
                guard distanceFromEdge < threshold else { sender.isEnabled = false; break }
                guard beginDroarVisibilityUpdate() else { sender.isEnabled = false; break }
                
            case .changed:
                let limitedPan = max(sender.translation(in: sender.view).x, -navController.view.frame.width)
                navController.view.transform = CGAffineTransform(translationX: limitedPan, y: 0)
                setContainerOpacity(abs(limitedPan) / drawerWidth)
                
            default:
                sender.isEnabled = true
                endDroarVisibilityUpdate(nil)
            }
        }
    }
    
    private static func setContainerOpacity(_ opacity: CGFloat) {
        containerViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: defaultContainerAlpha * opacity)
    }
    
    static func replaceGestureRecognizer(with recognizer: UIGestureRecognizer)
    {
        if let gestureRecognizer = gestureRecognizer {
            gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
        }
        
        gestureRecognizer = recognizer
        
        loadKeyWindow()?.addGestureRecognizer(recognizer)
    }
    
    static func beginDroarVisibilityUpdate() -> Bool {
        guard let activeVC = loadActiveResponder() as? UIViewController else { return false }
        guard navController?.view.transform.isIdentity ?? false else { return true }
        
        KnobManager.sharedInstance.registerDynamicKnobs(loadDynamicKnobs())
        KnobManager.sharedInstance.prepareForDisplay(tableView: viewController?.tableView)
        
        let screenSize = UIScreen.main.bounds.size
        
        containerViewController.view.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        navController.view.frame = CGRect(x: screenSize.width, y: 0, width: drawerWidth, height: screenSize.height)
        #if swift(>=4.2)
        containerViewController.willMove(toParent: activeVC)
        activeVC.view.window?.addSubview(containerViewController.view)
        activeVC.addChild(containerViewController)
        containerViewController.didMove(toParent: activeVC)
        #else
        containerViewController.willMove(toParentViewController: activeVC)
        activeVC.view.window?.addSubview(containerViewController.view)
        activeVC.addChildViewController(containerViewController)
        containerViewController.didMove(toParentViewController: activeVC)
        #endif
        
        viewController?.tableView.reloadData()
        
        return true
    }
    
    static func endDroarVisibilityUpdate(_ completion: (()->Void)?) {
        let translation = abs(navController.view.transform.tx)
        
        UIView.animate(withDuration: 0.25, animations: {
            if translation >= (navController.view.frame.size.width / 2) {
                navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
                setContainerOpacity(1)
            } else {
                navController.view.transform = CGAffineTransform.identity
                setContainerOpacity(0)
            }
        }, completion: { (complete) in
            if navController.view.transform.isIdentity {
                #if swift(>=4.2)
                containerViewController.willMove(toParent: nil)
                containerViewController.view.removeFromSuperview()
                containerViewController.removeFromParent()
                #else
                containerViewController.willMove(toParentViewController: nil)
                containerViewController.view.removeFromSuperview()
                containerViewController.removeFromParentViewController()
                #endif
                
                if let window = dismissalRecognizer.view {
                    window.removeGestureRecognizer(dismissalRecognizer)
                    window.addGestureRecognizer(gestureRecognizer)
                }
                
            } else {
                if let window = gestureRecognizer.view {
                    window.removeGestureRecognizer(gestureRecognizer)
                    window.addGestureRecognizer(dismissalRecognizer)
                }
            }
            
            completion?()
        })
    }
    
    @objc static func toggleVisibility(_ completion: (()->Void)?) {
        guard beginDroarVisibilityUpdate() else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            if navController.view.transform.isIdentity {
                navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
                setContainerOpacity(1)
            } else {
                navController.view.transform = CGAffineTransform.identity
                setContainerOpacity(0)
            }
        }) { (completed) in
            endDroarVisibilityUpdate(completion)
        }
    }
    
    private class GestureDelegate: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
