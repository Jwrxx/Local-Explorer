//
//  DiscoverViewController.swift
//  Local Explorer
//
//  Created by John Walker Jr on 4/29/25.
//

import UIKit
import MapKit
import CoreData

class DiscoverViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set user tracking mode to follow
        /* mapView.setUserTrackingMode(.follow, animated: true)
         
         // Fetch places from Core Data
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         let request: NSFetchRequest<Place> = Place.fetchRequest()
         
         var fetchedPlaces: [Place] = []
         do {
         fetchedPlaces = try context.fetch(request)
         } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
         }
         
         // Remove existing annotations
         self.mapView.removeAnnotations(self.mapView.annotations)
         
         // Add annotations for each place
         for place in fetchedPlaces {
         let latitude = place.latitude
         let longitude = place.longitude
         let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
         
         let annotation = MapPoint(latitude: latitude, longitude: longitude)
         annotation.coordinate = coordinate
         annotation.title = place.placeName
         // Optionally add other place details to subtitle
         annotation.subtitle = "Lat: \(latitude), Long: \(longitude)"
         
         // Add annotation to the map
         mapView.addAnnotation(annotation)
         }
         }
         } */
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
        
    }
}
