//
//  NewPlaceViewController.swift
//  Local Explorer
//
//  Created by John Walker Jr on 4/29/25.
//

import UIKit
import MapKit
import CoreData
import CoreLocation

class NewPlaceViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationBarDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate {
    
    var currentPlace: Place?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var txtName: UITextField!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var imgLocation: UIImageView!
    
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    
    @IBOutlet weak var takePhoto: UIButton!
    
    @IBOutlet weak var choosePhoto: UIButton!
    
    @IBOutlet weak var findLocation: UIButton!
    
    @IBOutlet weak var currentLocation: UIButton!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestLocation()

        // Do any additional setup after loading the view.
        
        if let place = currentPlace {
            txtName.text = place.placeName
            
            if let imageData = place.image {
                imgLocation.image = UIImage(data: imageData)
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = place.placeName
            mapView.addAnnotation(annotation)
            
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            //POSSIBLE ADDRESS TYPE BUTTON.isHidden = true
            navigationItem.rightBarButtonItem = nil
            takePhoto.isEnabled = false
            choosePhoto.isEnabled = false
            findLocation.isEnabled = false
            currentLocation.isEnabled = false
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            //POSSIBLE ADDRESS TYPE BUTTON.isHidden = true
            takePhoto.isEnabled = true
            choosePhoto.isEnabled = true
            findLocation.isEnabled = true
            currentLocation.isEnabled = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,target: self, action: #selector(self.savePlace))
        }
    }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardDidShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    
    @objc func keyboardWasShown(_ notification: Notification) {
        guard let info = notification.userInfo,
              let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
    }

    
    
    /*@IBAction func changeEditMode(_ sender: Any) {
        let isEditMode = sgmtEditMode.selectedSegmentIndex == 1
        txtName.isEnabled = isEditMode
        txtName.borderStyle = isEditMode ? .roundedRect : .none
        
        navigationItem.rightBarButtonItem = isEditMode
        ? UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(savePlace))
        : nil
    }*/
    
    @objc func savePlace(){
        if currentPlace == nil{
            let context = appDelegate.persistentContainer.viewContext
            currentPlace = Place(context: context)
        }
        currentPlace?.placeName = txtName.text ?? ""
        
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
        
        appDelegate.saveContext()
        
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            imgLocation.contentMode = .scaleAspectFit
            if currentPlace == nil {
                let context = appDelegate.persistentContainer.viewContext
                currentPlace = Place(context: context)
            }
            currentPlace?.image = image.jpegData(compressionQuality: 1.0)
            imgLocation.image = image
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryController = UIImagePickerController()
            photoLibraryController.sourceType = .photoLibrary
            photoLibraryController.delegate = self
            photoLibraryController.allowsEditing = true
            self.present(photoLibraryController, animated: true, completion: nil)
        } //Need to add alert or something to check if the picture is in the library
    }
    
    
    @IBAction func currentLocation(_ sender: Any) {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let location = locations.first {
            let coordinate = location.coordinate
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
            
            mapView.removeAnnotations(mapView.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "Current Location"
            mapView.addAnnotation(annotation)
            
            if currentPlace ==  nil {
                let context = appDelegate.persistentContainer.viewContext
                currentPlace = Place(context: context)
            }
            currentPlace?.latitude = coordinate.latitude
            currentPlace?.longitude = coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        let locationInView = sender.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Selected Location"
        mapView.addAnnotation(annotation)
        
        if currentPlace == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentPlace = Place(context: context)
        }
        
        currentPlace?.latitude = coordinate.latitude
        currentPlace?.longitude = coordinate.longitude
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        guard let locationString = txtName.text, !locationString.isEmpty else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = locationString
                self.mapView.addAnnotation(annotation)
                // Adjust the region to zoom out
                            let mediumZoomOutRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000) // Zoom out by increasing the meters
                            self.mapView.setRegion(mediumZoomOutRegion, animated: true)
                
                // Adjust the region to zoom out
                            let zoomOutRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000) // Zoom out by increasing the meters
                            self.mapView.setRegion(zoomOutRegion, animated: true)
                
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                self.mapView.setRegion(region, animated: true)
                
                if self.currentPlace == nil {
                    let context = self.appDelegate.persistentContainer.viewContext
                    self.currentPlace = Place(context: context)
                }
                
                self.currentPlace?.latitude = coordinate.latitude
                self.currentPlace?.longitude = coordinate.longitude
            }
        }
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
