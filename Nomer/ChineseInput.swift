//
//  ChineseInput.swift
//  Nomer
//
//  Created by wentao computer on 5/9/19.
//  Copyright © 2019 Summer Project. All rights reserved.
//

import UIKit
import Alamofire

class ChineseInput: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var genderPrompt: UISegmentedControl!
    @IBOutlet weak var genderIndicator: UILabel!
    @IBOutlet weak var namePrompt: UIImageView!
    @IBOutlet weak var arrow: UIButton!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    var name: String? = ""
    var gender: String? = "male"
    var returned_name: String? = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameText.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func genderToggle(_ sender: Any) {
        switch genderPrompt.selectedSegmentIndex
        {
        case 0:
            gender = "male"
        case 1:
            gender = "female"
        default:
            break
        }
    }
    
    @IBAction func start(_ sender: AnyObject)
    {
        activityIndicator.center = self.view.center
        activityIndicator.color = .white
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        view.addSubview(activityIndicator)

        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    @IBAction func stop(_ sender: AnyObject)
    {
        activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    func getNameData(p : Parameters, completion: ()->()){
        Alamofire.request("http://127.0.0.1:5000/Chinese", method: .post, parameters: p).responseString { response in
//            print((response.result.value!))
            self.returned_name = response.result.value!
        }
        completion()
    }
    
    @IBAction func loadButton(_ sender: Any) {
        genderIndicator.text = nameText.text
        name = nameText.text
        nameText.isHidden = true;
        genderPrompt.isHidden = true;
        namePrompt.isHidden = true;
        arrow.isHidden = true;
        
        start(self);
        
//        REQUEST TO REST API

        let parameters: Parameters = [
            "name": name!,
            "gender": gender!
        ]
        
        Alamofire.request("http://ccxxgao.pythonanywhere.com/Chinese", method: .post, parameters: parameters).responseString { response in
//            print((response.result.value!))
            if response.result.value != nil {
                self.returned_name = response.result.value!
            }
            else {
                self.returned_name = "not connected to internet"
            }
            self.stop(self);
            self.performSegue(withIdentifier: "toOutput", sender: self)
        }
    }
 
    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "toHome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let c2eoutput = segue.destination as? C2EOutput{c2eoutput.name = returned_name}
    }

}
