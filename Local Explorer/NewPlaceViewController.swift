//
//  NewPlaceViewController.swift
//  Local Explorer
//
//  Created by John Walker Jr on 4/29/25.
//

import UIKit

class NewPlaceViewController: UIViewController {
    
    var currentPlace: Place?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*if currentPlace != nil {
            txtName.txt = currentPlace!.placeName
            txtlatitude.txt = currentPlace!.latitude
            txtlongitude.txt = currentPlace!.longitude
            let formatter = DateFormatter()
            formatter.dataStyle = .short
            if currentPlace!.date != nil {
                
            }
        }*/
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
