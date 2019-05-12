//
//  E2COutput.swift
//  Nomer
//
//  Created by wentao computer on 5/10/19.
//  Copyright © 2019 Summer Project. All rights reserved.
//

import UIKit

class E2COutput: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel?
    
    var name: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.text = name?.replacingOccurrences(of: "\"", with: "")
    }
    
    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "toh", sender: self)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
