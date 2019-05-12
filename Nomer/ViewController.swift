//
//  ViewController.swift
//  Nomer
//
//  Created by wentao computer on 5/9/19.
//  Copyright © 2019 Summer Project. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view.backgroundColor = UIColor(red: 138/255, green: 192/255, blue: 206/255, alpha: 1)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func C2E(_ sender: Any) {
        performSegue(withIdentifier: "toChineseInput", sender: self)
    }
    
    @IBAction func E2C(_ sender: Any) {
        performSegue(withIdentifier: "toEnglishInput", sender: self)
    }
}
