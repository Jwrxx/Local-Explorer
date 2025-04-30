//
//  NewPlaceTableViewController.swift
//  Local Explorer
//
//  Created by John Walker Jr on 4/29/25.
//

import UIKit
import CoreData

class NewPlaceTableViewController: UITableViewController {
    
    var places: [NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataFromDatabase()
        tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPlace" {
            let placeController = segue.destination as? NewPlaceViewController
            let selectedRow = self.tableView.indexPath(for: sender as! UITableViewCell)?.row
            let selectedPlace = places[selectedRow!] as? Place
            placeController?.currentPlace = selectedPlace!
            
            
        }
    }
    
    func loadDataFromDatabase() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Place")

        do {
            places = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return places.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath)
        cell.accessoryType = UITableViewCell.AccessoryType.detailDisclosureButton
        
        let place = places[indexPath.row] as? Place
        cell.textLabel?.text = place?.placeName
        //cell.detailTextLabel?.text = place?.locationDescription

        // Configure the cell...

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let place = places[indexPath.row] as! Place
            let context = appDelegate.persistentContainer.viewContext
            context.delete(place)
            do {
                try context.save()
            } catch {
                fatalError("Error saving context: \(error)")
            }
            loadDataFromDatabase()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPlace = places[indexPath.row] as! Place
            let name = selectedPlace.placeName ?? "Unnamed"

            let actionHandler: (UIAlertAction) -> Void = { _ in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PlaceController") as? NewPlaceViewController
                controller?.currentPlace = selectedPlace
                self.navigationController?.pushViewController(controller!, animated: true)
            }

            let alertController = UIAlertController(title: "Place Selected",
                                                    message: "Selected row: \(indexPath.row) (\(name))", preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let actionDetails = UIAlertAction(title: "Show Details", style: .default, handler: actionHandler)

            alertController.addAction(actionCancel)
            alertController.addAction(actionDetails)
            present(alertController, animated: true, completion: nil)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


