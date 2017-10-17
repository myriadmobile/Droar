//
//  SectionManger.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

public enum BasicSourceType: Int {
    case buildInfo, deviceInfo, reporting
    static let defaultValues: [BasicSourceType] = [.buildInfo, .deviceInfo, .reporting]
}

internal class SectionManager {
    
    static let sharedInstance = SectionManager()
    private var basicSources = [IDroarSource]()
    private var staticSources = [IDroarSource]()
    private var dynamicSources = [IDroarSource]()
    public private(set) var sources = [IDroarSource]()
    
    private init() {
        registerBasicSources(BasicSourceType.defaultValues)
    }
    
    public func registerBasicSources(_ sources: [BasicSourceType]) {
        basicSources = [IDroarSource]()
        
        for type in sources {
            switch type {
            case .buildInfo: basicSources.append(BuildInfoSource()); break;
            case .deviceInfo: basicSources.append(DeviceInfoSource()); break;
            case .reporting: basicSources.append(ReportingSource()); break;
            }
        }
        
        sortSources()
    }
    
    public func registerStaticSource(_ source: IDroarSource) {
        if (!staticSources.contains(where: { (existingSource) -> Bool in
            return existingSource === source
        })) {
            staticSources.append(source)
            sortSources()
        }
    }
    
    public func registerDynamicSources(_ sources: [IDroarSource]) {
        self.dynamicSources = sources
        sortSources()
    }
    
    private func sortSources() {
        sources = dynamicSources
        sources.append(contentsOf: staticSources)
        sources.append(contentsOf: basicSources)
        
        sources.sort { (source1, source2) -> Bool in
            let position1 = source1.droarSectionPosition()
            let position2 = source2.droarSectionPosition()
            
            if (position1.position != position2.position)
            {
                return position1.position.rawValue <= position2.position.rawValue
            }
            
            return position1.priority.rawValue <= position2.priority.rawValue
        }
    }
    
    //    public func initializeSections(tableView: UITableView) {
    //        for section in sources {
    //            if let performSetupAction = section.droarSectionPerformSetup {
    //                performSetupAction(tableView)
    //            }
    //        }
    //    }
}
