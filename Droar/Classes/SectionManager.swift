//
//  SectionManger.swift
//  Pods
//
//  Created by Nathan Jangula on 9/1/17.
//
//

import Foundation

internal class SectionManager {
    
    static let sharedInstance = SectionManager()
    private var staticSources = [IDroarSource]()
    public private(set) var sources = [IDroarSource]()

    private init() {
        staticSources.append(BuildInfoSource())
        staticSources.append(DeviceInfoSource())
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
        self.sources = sources
        sortSources()
    }
    
    private func sortSources() {
        for source in staticSources {
            if (!sources.contains(where: { (existingSource) -> Bool in
                return existingSource === source
            })) {
                sources.append(source)
            }
        }
        
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
