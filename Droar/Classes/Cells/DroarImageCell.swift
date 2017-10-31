//
//  DroarImageCell.swift
//  Droar
//
//  Created by Nathan Jangula on 10/26/17.
//

import Foundation

public class DroarImageCell : UITableViewCell, DroarCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var largeImageView: UIImageView!
    
    public static func create(title: String? = "", image: UIImage? = nil, allowSelection: Bool = false) -> DroarImageCell {
        var cell: DroarImageCell?
        
        for view in Bundle.podBundle.loadNibNamed("DroarImageCell", owner: self, options: nil) ?? [Any]() {
            if view is DroarImageCell {
                cell = view as? DroarImageCell
            }
        }
        
        cell?.titleLabel.text = title
        cell?.largeImageView?.image = image
        cell?.selectionStyle = allowSelection ? .gray : .none

        return cell ?? DroarImageCell()
    }
    
    public func stateDump() -> [String : String]? {
        // TODO: Do we care to know what image was being displayed?  I wrote this mainly to show the Myriad Logo
        return nil
    }
}
