//
//  MyriadKnob.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation

internal class MyriadKnob : DroarKnob {
    
    func droarSectionTitle() -> String {
        return ""
    }
    
    func droarSectionPosition() -> PositionInfo {
        return PositionInfo(position: .bottom, priority: .low)
    }
    
    func droarSectionNumberOfCells() -> Int {
        return 1
    }
    
    func droarSectionCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DroarImageCell") as? DroarImageCell ?? DroarImageCell.create()
        
        cell.titleLabel.text = "Powered By:"
        cell.largeImageView.image = UIImage(named: "MyriadLogo")
        
        return cell
    }
}
