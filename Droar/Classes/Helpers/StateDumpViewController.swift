//
//  StateDumpViewController.swift
//  Droar
//
//  Created by Nathan Jangula on 3/7/18.
//

import UIKit

class StateDumpViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    private var stateDump: String?
    
    public static func create(stateDump: String) -> StateDumpViewController {
        let vc = UIStoryboard.stateDump.instantiateViewController(withIdentifier: "StateDumpViewController") as! StateDumpViewController
        vc.stateDump = stateDump
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = stateDump
    }
    
    @IBAction func tappedExport(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [stateDump ?? ""], applicationActivities: nil)
        Droar.present(activityVC, animated: true, completion: nil)
    }
}
