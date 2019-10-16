//
//  DroarGestureHandler.swift
//  Droar
//
//  Created by Nathan Jangula on 10/27/17.
//

import Foundation

internal extension Droar {
    
    //State
    static var openRecognizer: UIGestureRecognizer!
    static var dismissalRecognizer: UISwipeGestureRecognizer!
    
    static var threshold: CGFloat!
    private static let gestureDelegate = DroarGestureDelegate()
    
    //Setup
    static func configureRecognizerForType(_ type: DroarGestureType, _ threshold: CGFloat) {
        self.threshold = threshold
        
        //Setup show gesture
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
        
        //Setup dismiss gesture
        if let old = dismissalRecognizer { old.view?.removeGestureRecognizer(old) }
        dismissalRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissalRecognizerEvent))
        dismissalRecognizer.direction = .right
        dismissalRecognizer.delegate = gestureDelegate
    }
    
    //Handlers
    @objc private static func handleTripleTap(sender: UITapGestureRecognizer?) {
        guard let _ = sender else { print("Missing sender."); return }
        toggleVisibility()
    }
    
    @objc private static func handlePan(sender: UIPanGestureRecognizer?) {
        guard let sender = sender else { print("Missing sender."); return }
        
        switch sender.state {
        case .began:
            // Make sure they started on the far edge
            let distanceFromEdge = sender.view!.bounds.width - sender.location(in: sender.view).x
            guard distanceFromEdge < threshold else { sender.isEnabled = false; break }
            guard beginDroarVisibilityUpdate() else { sender.isEnabled = false; break }
        case .changed:
            let limitedPan = max(sender.translation(in: sender.view).x, -navController.view.frame.width)
            navController.view.transform = CGAffineTransform(translationX: limitedPan, y: 0)
            let percent = abs(limitedPan) / drawerWidth
            window.setActivationPercent(percent)
        default:
            sender.isEnabled = true
            
            //Gesture finished; now we must determine what the final state is.
            if abs(navController.view.transform.tx) >= (navController.view.frame.size.width / 2) {
                openDroar()
            } else {
                closeDroar()
            }
        }
    }
    
    //Visibility Updates
    private static func beginDroarVisibilityUpdate() -> Bool {
        //Ensure the window is visible
        let appWindow = loadKeyWindow()
        window.makeKeyAndVisible()
        window.addSubview(navController.view)
        appWindow?.makeKeyAndVisible()
        
        //Update for knob state
        KnobManager.sharedInstance.registerDynamicKnobs(loadDynamicKnobs())
        KnobManager.sharedInstance.prepareForDisplay(tableView: viewController?.tableView)
        
        return true
    }
    
    private static func loadDynamicKnobs() -> [DroarKnob] {
        //Note: I think this dynamic knob feature could use some rethinking.
        if let activeVC = loadActiveResponder() {
            
            let candidateVCs = activeVC.loadActiveViewControllers()
            var knobs = [DroarKnob]()
            
            for candidate in candidateVCs {
                if candidate is DroarKnob {
                    knobs.append(candidate as! DroarKnob)
                }
            }
            
            return knobs
        }
        
        return []
    }
    
    //Convenience
    static func replaceGestureRecognizer(with recognizer: UIGestureRecognizer) {
        //Remove old (if applicable)
        if let gestureRecognizer = openRecognizer {
            gestureRecognizer.view?.removeGestureRecognizer(gestureRecognizer)
        }
        
        //Add new
        openRecognizer = recognizer
        loadKeyWindow()?.addGestureRecognizer(openRecognizer)
    }
    
    @objc private static func dismissalRecognizerEvent() { closeDroar() } //We can't call closeDroar from the selector because of the optional completion block
    
}

//Gesture Delegates
fileprivate class DroarGestureDelegate: NSObject, UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == Droar.openRecognizer {
            
        } else if gestureRecognizer == Droar.dismissalRecognizer {
            if touch.view is UISlider { return false } //Prevent pan from interfering with slider
        }
        
        return true
    }
    
}
