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
        toggleVisibility()
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
                navController.view.transform = CGAffineTransform(translationX: max(sender.translation(in: sender.view).x, -navController.view.frame.width), y: 0)
                
            default:
                sender.isEnabled = true
                endDroarVisibilityUpdate()
            }
        }
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
        
        navController.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: drawerWidth, height: UIScreen.main.bounds.size.height)
        navController.willMove(toParentViewController: activeVC)
        activeVC.addChildViewController(navController)
        activeVC.view.addSubview(navController.view)
        navController.didMove(toParentViewController: activeVC)
        
        viewController?.tableView.reloadData()
        
        return true
    }
    
    static func endDroarVisibilityUpdate() {
        let translation = abs(navController.view.transform.tx)
        
        UIView.animate(withDuration: 0.25, animations: {
            if translation >= (navController.view.frame.size.width / 2) {
                navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
            } else {
                navController.view.transform = CGAffineTransform.identity
            }
        }, completion: { (complete) in
            if navController.view.transform.isIdentity {
                navController.willMove(toParentViewController: nil)
                navController.view.removeFromSuperview()
                navController.removeFromParentViewController()
                
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
        })
    }
    
    @objc static func toggleVisibility() {
        guard beginDroarVisibilityUpdate() else { return }
        
        UIView.animate(withDuration: 0.25, animations: {
            if navController.view.transform.isIdentity {
                navController.view.transform = CGAffineTransform(translationX: -navController.view.frame.size.width, y: 0)
            } else {
                navController.view.transform = CGAffineTransform.identity
            }
        }) { (completed) in
            endDroarVisibilityUpdate()
        }
    }
    
    private class GestureDelegate: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}
