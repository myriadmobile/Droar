//
//  DroarGestureHandler.swift
//  Droar
//
//  Created by Nathan Jangula on 10/27/17.
//

import Foundation

internal extension Droar {
    static func configureRecognizerForType(_ type: DroarGestureType)
    {
        switch type {
        case .tripleTap:
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(handleTripleTap))
            recognizer.numberOfTapsRequired = 3
            replaceGestureRecognizer(with: recognizer)
        }
    }
    
    @objc private static func handleTripleTap() {
        toggleVisibility()
    }
    
    static func replaceGestureRecognizer(with recognizer: UIGestureRecognizer)
    {
        if let gestureRecognizer = gestureRecognizer {
            gestureRecognizer.view?.removeGestureRecognizer(recognizer)
        }
        
        gestureRecognizer = recognizer
        
        loadKeyWindow()?.addGestureRecognizer(recognizer)
    }
    
    @objc static func toggleVisibility() {
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
