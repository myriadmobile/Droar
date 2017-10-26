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
        cell?.imageView?.image = image
        cell?.isUserInteractionEnabled = allowSelection
        
        return cell ?? DroarImageCell()
    }
    
    public func stateDump() -> [String : String]? {
        return nil
//        guard let text = titleLabel.text, let detailText = detailLabel.text else { return nil }
//        return [text : detailText]
    }
}
