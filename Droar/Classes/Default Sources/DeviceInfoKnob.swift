//
//  DeviceInfoKnob.swift
//  Droar
//
//  Created by Nathan Jangula on 10/11/17.
//

import Foundation
import SDVersion

internal class DeviceInfoKnob : DroarKnob {
    private enum DeviceInfoRow: Int {
        case name = 0
        case systemName = 1
        case systemVersion = 2
        case model = 3
        case resolution = 4
        case ipAddress = 5
        case identifier = 6
        case count = 7
    }
    func droarKnobTitle() -> String {
        return "Device Info"
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .bottom, priority: .low)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return DeviceInfoRow.count.rawValue
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DroarLabelCell") as? DroarLabelCell ?? DroarLabelCell.create()
        cell.selectionStyle = .none

        let device = UIDevice.current
        
        switch DeviceInfoRow(rawValue:index)! {
        case .name:
            cell.titleLabel.text = "Name"
            cell.detailLabel.text = device.name
        case .systemName:
            cell.titleLabel.text = "System Name"
            cell.detailLabel.text = device.systemName
        case .systemVersion:
            cell.titleLabel.text = "iOS Version"
            cell.detailLabel.text = device.systemVersion
        case .model:
            cell.titleLabel.text = "Model"
            cell.detailLabel.text = SDiOSVersion.deviceName(for: SDiOSVersion.deviceVersion())
        case .resolution:
            cell.titleLabel.text = "Screen Resolution"
            cell.detailLabel.text = getScreenResolution()
        case .ipAddress:
            cell.titleLabel.text = "IP Address"
            cell.detailLabel.text = getIPAddress()
        case .identifier:
            cell.titleLabel.text = "Identifier"
            cell.detailLabel.text = device.identifierForVendor?.uuidString
        case .count:
            cell.titleLabel.text = ""
            cell.detailLabel.text = ""
        }
        
        return cell
    }
    
    func getScreenResolution() -> String {
        var size = UIScreen.main.bounds.size
        let scale = UIScreen.main.scale
        
        size.width = size.width * scale
        size.height = size.height * scale
        
        return String(format:"%.0f x %.0f", size.width, size.height)
    }
    
    func getIPAddress() -> String {
        var address = "error"
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return address }
        guard let firstAddr = ifaddr else { return address }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}
