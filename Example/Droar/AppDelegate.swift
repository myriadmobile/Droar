//
//  AppDelegate.swift
//  Droar
//
//  Created by Janglinator on 06/05/2017.
//  Copyright (c) 2017 Janglinator. All rights reserved.
//

import UIKit
import Droar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var cells = [DroarCell]()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        Droar.start()
        
        Droar.register(self)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: DroarKnob {
    func droarKnobWillBeginLoading(tableView: UITableView?) {
        cells = []
    }
    
    func droarKnobTitle() -> String {
        return "Example Rows"
    }
    
    func droarKnobPosition() -> PositionInfo {
        return PositionInfo(position: .top, priority: .high)
    }
    
    func droarKnobNumberOfCells() -> Int {
        return 7
    }
    
    func droarKnobCellForIndex(index: Int, tableView: UITableView) -> DroarCell {
        
        var cell: DroarCell
        
        switch index {
        case 0:
            cell = DroarSwitchCell.create(title: "Rows Enabled", defaultValue: true, allowSelection: false, onValueChanged: { (value) in
                for cell in self.cells {
                    cell.setEnabled(value)
                }
            })
            
            return cell
        case 1:
            cell = DroarLabelCell.create(title: "DroarLabelCell", detail: "Click Me!", allowSelection: true)
        case 2:
            cell = DroarTextFieldCell.create(title: "DroarTextFieldCell", placeholder: "Type here", text: nil, allowSelection: false, onTextChanged: { (text) in
                print(text ?? "")
            })
        case 3:
            cell = DroarImageCell.create(title: "DroarImageCell", image: UIImage(named:"DroarIcon"), allowSelection: true)
        case 4:
            cell = DroarSwitchCell.create(title: "DroarSwitchCell", defaultValue: false, allowSelection: false, onValueChanged: { (value) in
                print(value)
            })
        case 5:
            cell = DroarSegmentedCell.create(title: "DroarSegmentedCell", values: ["0", "1", "2"], defaultIndex: nil, allowSelection: false, onValueChanged: { (value) in
                print(value)
            })
        case 6:
            cell = DroarSliderCell.create(title: "DroarSliderCell", value: 0.5, min: 0, max: 1, allowSelection: false, onValueChanged: { (value) in
                print(value)
            })
        default:
            cell =  DroarLabelCell.create(title: "", detail: "", allowSelection: true)
        }
        
        cells.append(cell)
        
        return cell
    }
    
    func droarKnobIndexSelected(tableView: UITableView, selectedIndex: Int) {
        print("Clicked!")
    }
}
