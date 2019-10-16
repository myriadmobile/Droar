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
    
    //Singleton
    static let sharedInstance = KnobManager()
    
    //State
    private var defaultKnobs = [DroarKnob]()
    private var staticKnobs = [DroarKnob]()
    private var dynamicKnobs = [DroarKnob]()
    public private(set) var visibleSections = [DroarKnobSection]()
    
    //Init
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
            if Droar.isStarted {
                knob.droarKnobDidFinishRegistering?()
            }
            sortKnobs()
        }
    }
    
    public func registerDynamicKnobs(_ knobs: [DroarKnob]) {
        self.dynamicKnobs = knobs
        if Droar.isStarted {
            for knob in knobs {
                knob.droarKnobDidFinishRegistering?()
            }
        }
        sortKnobs()
    }
    
    public func prepareForStart() {
        for section in visibleSections {
            for knob in section.knobs {
                knob.droarKnobDidFinishRegistering?()
            }
        }
    }
    
    public func prepareForDisplay(tableView: UITableView?) {
        for section in visibleSections {
            for knob in section.knobs {
                knob.droarKnobWillBeginLoading?(tableView: tableView)
            }
        }
        
        tableView?.reloadData() //TODO: Does this make sense?
    }
    
    private func sortKnobs() {
        visibleSections = []
        
        func add(_ knobs: [DroarKnob]) {
            for knob in knobs {
                let title = knob.droarKnobTitle()
                if let section = visibleSections.first(where: { (section) -> Bool in
                    section.title.lowercased() == title.lowercased()
                }) {
                    section.add(knob)
                } else {
                    visibleSections.append(DroarKnobSection(knob))
                }
            }
        }
        
        add(dynamicKnobs)
        add(staticKnobs)
        add(defaultKnobs)
        
        visibleSections.sort { (section1, section2) -> Bool in
            let position1 = section1.positionInfo
            let position2 = section2.positionInfo
            
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
            for section in visibleSections {
                for index in 0 ..< section.numberOfCells() {
                    let cell = section.droarKnobCellForIndex(index: index, tableView: tableView)
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
