//
//  MyriadKnob.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation
import WebKit

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
        cell.isUserInteractionEnabled = true

        return cell
    }
    
    func droarSectionIndexSelected(tableView: UITableView, selectedIndex: Int) {
        if let url = URL(string: "https://www.myriadmobile.com") {
            let alert = UIAlertController(title: "Open in Safari?", message: url.absoluteString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                UIApplication.shared.openURL(url)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            Droar.present(alert, animated: true, completion: nil)
        }
    }
}
