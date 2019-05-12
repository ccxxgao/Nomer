//
//  EnglishInput.swift
//  Nomer
//
//  Created by wentao computer on 5/9/19.
//  Copyright © 2019 Summer Project. All rights reserved.
//

import UIKit
import Alamofire

class EnglishInput: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var namePrompt: UIImageView!
    @IBOutlet weak var arrow: UIButton!
    @IBOutlet weak var genderPrompt: UISegmentedControl!
    
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
    
    @IBAction func loadButton(_ sender: Any) {
        name = nameText.text;
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
        
        print(parameters)
        
        Alamofire.request("http://127.0.0.1:5000/English", method: .post, parameters: parameters).responseString { response in
//            print((response.result.value!))
            if (response.result.value != nil){
                self.returned_name = self.une(i : response.result.value!)
            }
            else {
                self.returned_name = "not connected to internet"
            }

            self.stop(self);
            self.performSegue(withIdentifier: "toOut", sender: self)
        }
    }
    
    func une(i: String) -> String {
        let transform = "Any-Hex/Java"
        let input = i as NSString
        var convertedString = input.mutableCopy() as! NSMutableString
        CFStringTransform(convertedString, nil, transform as NSString, true)
        
        return convertedString as String
    }
    
    @IBAction func toHome(_ sender: Any) {
        performSegue(withIdentifier: "tohome", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let e2cOutput = segue.destination as? E2COutput{e2cOutput.name = returned_name}
    }

}
