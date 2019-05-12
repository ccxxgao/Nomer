//
//  C2EOutput.swift
//  Nomer
//
//  Created by wentao computer on 5/9/19.
//  Copyright © 2019 Summer Project. All rights reserved.
//

import UIKit

class C2EOutput: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel?
    
//    var contact: Contact?
    var name: String? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.text = name?.replacingOccurrences(of: "\"", with: "")
    }

    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "toHomeScreen", sender: self)
    }
}
