//
//  KnobManager.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

@objc public enum DefaultKnobType: Int {
    case buildInfo = 0
    case deviceInfo = 1
    case processInfo = 2
    case reporting = 3
    case myriad = 4
    internal static let defaultValues: [DefaultKnobType] = [.buildInfo, .deviceInfo, .processInfo, .reporting, .myriad]
}

internal class KnobManager {
    
    static let sharedInstance = KnobManager()
    private var defaultKnobs = [DroarKnob]()
    private var staticKnobs = [DroarKnob]()
    private var dynamicKnobs = [DroarKnob]()
    public private(set) var visibleKnobs = [DroarKnob]()
    
    private init() {
        registerDefaultKnobs(DefaultKnobType.defaultValues.reversed())
    }
    
    public func registerDefaultKnobs(_ types: [DefaultKnobType]) {
        defaultKnobs = [DroarKnob]()
        
        for type in types {
            switch type {
            case .buildInfo: defaultKnobs.append(BuildInfoKnob())
            case .deviceInfo: defaultKnobs.append(DeviceInfoKnob())
            case .processInfo: defaultKnobs.append(ProcessInfoKnob())
            case .reporting: defaultKnobs.append(ReportingKnob())
            case .myriad: defaultKnobs.append(MyriadKnob())
            }
        }
        
        sortKnobs()
    }
    
    public func registerStaticKnob(_ knob: DroarKnob) {
        if (!staticKnobs.contains(where: { (existingKnob) -> Bool in
            return existingKnob === knob
        })) {
            staticKnobs.append(knob)
            sortKnobs()
        }
    }
    
    public func registerDynamicKnobs(_ knobs: [DroarKnob]) {
        self.dynamicKnobs = knobs
        sortKnobs()
    }
    
    public func prepareForDisplay(tableView: UITableView?) {
        for knob in visibleKnobs {
            if let performSetupAction = knob.droarKnobWillBeginLoading(tableView:) {
                performSetupAction(tableView)
            }
        }
    }
    
    private func sortKnobs() {
        visibleKnobs = []
        visibleKnobs.append(contentsOf: dynamicKnobs)
        visibleKnobs.append(contentsOf: staticKnobs)
        visibleKnobs.append(contentsOf: defaultKnobs)
        
        visibleKnobs.sort { (knob1, knob2) -> Bool in
            let position1 = knob1.droarKnobPosition()
            let position2 = knob2.droarKnobPosition()
            
            if (position1.position != position2.position)
            {
                return position1.position.rawValue <= position2.position.rawValue
            }
            
            return position1.priority.rawValue <= position2.priority.rawValue
        }
    }
    
    public func generateStateDump() -> [String: String] {
        var dump = [String: String]()
        
        if let tableView = Droar.viewController?.tableView {
            for knob in visibleKnobs {
                for index in 0 ..< knob.droarKnobNumberOfCells() {
                    let cell = knob.droarKnobCellForIndex(index: index, tableView: tableView)
                    if let cellDump = cell.stateDump() {
                        dump.merge(cellDump, uniquingKeysWith: { (oldValue, newValue) -> String in
                            return newValue
                        })
                    }
                }
            }
        }
        
        return dump
    }
}
