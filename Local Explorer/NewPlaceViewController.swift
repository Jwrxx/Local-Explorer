//
//  NewPlaceViewController.swift
//  Local Explorer
//
//  Created by John Walker Jr on 4/29/25.
//

import UIKit
import MapKit
import CoreData

class NewPlaceViewController: UIViewController {
    
    var currentPlace: Place?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if currentPlace != nil {
            txtName.text = currentPlace!.placeName
        }
    }
    

    @IBAction func takePhoto(_ sender: Any) {
        
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        
    }
    
    
    @IBAction func currentLocation(_ sender: Any) {
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
