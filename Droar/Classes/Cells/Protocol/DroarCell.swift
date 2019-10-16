//
//  DroarCell.swift
//  Droar
//
//  Created by Nathan Jangula on 10/25/17.
//

import Foundation

@objc public protocol DroarCell where Self: UITableViewCell {
    @objc func stateDump() -> [String: String]?
    @objc func setEnabled(_ enabled: Bool)
}
