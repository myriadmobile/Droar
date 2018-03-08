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

public class DroarKnobSection {
    public private(set) var knobs: [DroarKnob]
    public private(set) var title: String
    public private(set) var positionInfo: PositionInfo
    public private(set) var cellCountMappings: [Int]
    
    public init(_ knob: DroarKnob) {
        self.knobs = [knob]
        self.title = knob.droarKnobTitle()
        self.positionInfo = knob.droarKnobPosition()
        self.cellCountMappings = [knob.droarKnobNumberOfCells()]
    }
    
    public func add(_ knob: DroarKnob) {
        self.knobs.append(knob)
        
        let positionInfo = knob.droarKnobPosition()
        let position = max(self.positionInfo.position, positionInfo.position)
        let priority = max(self.positionInfo.priority, positionInfo.priority)
        self.positionInfo = PositionInfo(position: position, priority: priority)
        
        cellCountMappings.append(knob.droarKnobNumberOfCells())
    }
    
    func numberOfCells() -> Int {
        var count = 0
        
        for sectionCount in cellCountMappings {
            count += sectionCount
        }
        
        return count
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let indexPath = mappedIndex(index)
        return knobs[indexPath.section].droarKnobCellForIndex(index: indexPath.row, tableView: tableView)
    }
    
    func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int) {
        let indexPath = mappedIndex(selectedIndex)
        knobs[indexPath.section].droarKnobIndexSelected?(tableView: tableView, selectedIndex: indexPath.row)
    }
    
    private func mappedIndex(_ index: Int) -> NSIndexPath {
        var section = 0
        var count = 0
        
        for sectionCount in cellCountMappings {
            if count + sectionCount <= index {
                section += 1
                count += sectionCount
            } else {
                break
            }
        }
        
        return NSIndexPath(row: index - count, section: section)
    }
}

internal class KnobManager {
    
    static let sharedInstance = KnobManager()
    private var defaultKnobs = [DroarKnob]()
    private var staticKnobs = [DroarKnob]()
    private var dynamicKnobs = [DroarKnob]()
    public private(set) var visibleSections = [DroarKnobSection]()
    
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
        for section in visibleSections {
            for knob in section.knobs {
                knob.droarKnobWillBeginLoading?(tableView: tableView)
            }
        }
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
