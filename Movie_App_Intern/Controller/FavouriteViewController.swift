//
//  FavouriteViewController.swift
//  Movies_App_Intern
//
//  Created by Macbook on 08/02/2021.
//

import UIKit
import CoreData
class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    // Initializations
    @IBOutlet var tableView : UITableView!
    @IBOutlet var no_fav_view : UIView! // View That Display When There is no Favourites
    
    @IBOutlet weak var DeleteAll: UIBarButtonItem!
    
    var favourites : [Fav_Mov_MO] = []
    var isSelected : Bool = false
    var fetchResultsController: NSFetchedResultsController<Fav_Mov_MO>!
    // End of Initalizations 
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide the No Favourite View As Default
        tableView.backgroundView = no_fav_view
        no_fav_view.isHidden = true
        // ----------------------------------------
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.tintColor = .white // make backButton Color white
        DeleteAll.tintColor = UIColor.clear
        // fetching the data from Core Data and put it in favourites array to display it in table view
        let fetchRequest : NSFetchRequest<Fav_Mov_MO> = Fav_Mov_MO.fetchRequest()
        let sortDiscriptor = NSSortDescriptor(key: "movie_name", ascending: true)
        fetchRequest.sortDescriptors = [sortDiscriptor]
       if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
           let context = appdelegate.persistentContainer.viewContext
           fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                if let fetchedobject = fetchResultsController.fetchedObjects{
                    favourites = fetchedobject
                }
            }
            catch{
                print(error)
            }}
        // End of Fetching Data from Core Data
    }
    // Detrmine The Number of rows in tableView if there's no Rows Display No-Favourites View if there's Rows Return There number
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if favourites.count == 0 {
                tableView.separatorStyle = .none
                no_fav_view.isHidden = false
                DeleteAll.tintColor = UIColor.clear
                return 0
                
            }
            else {
                tableView.separatorStyle = .singleLine
                no_fav_view.isHidden = true
                DeleteAll.tintColor = UIColor.white
                return favourites.count
            }}
    // Button Used to Delete all Data from Core Data
    @IBAction func Delete_All_Tap() {
        if favourites.count == 0 {
            return
        }
        let alertController = UIAlertController(title: "Are You Sure to Delete All Favourites", message: "", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete All", style: .destructive) { (action) in
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
                let context = appDelegate.persistentContainer.viewContext
            for favourite in self.favourites {
                context.delete(favourite)
                appDelegate.saveContext()
            }}}
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(CancelAction)
        present(alertController, animated: true, completion: nil)
      }
    //-----------------------------------------------------
    //When the Cell is Selected Go to Detail View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "Show", sender: self)
        }
    //------------------------------------------------------
    //Table view Animation
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          // Define the initial state (Before the animation)
            cell.alpha = 0

        // Define the final state (After the animation)
        UIView.animate(withDuration: 0.5, animations: { cell.alpha = 1 })
    }
    //End of tableView Animation
    
    //Display Data in Rows of Movie Details The Poster Image , name , Rate and Release Date
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Fav_cell") as! FavouriteTableViewCell
            cell.Name.text = favourites[indexPath.row].movie_name
            cell.Rate.text = favourites[indexPath.row].rating
            cell.Release_Data.text = favourites[indexPath.row].release_date
            cell.Poster_Image.downloaded(from: favourites[indexPath.row].poster_image ?? "")
            //Delete One Movie form Table View
            cell.handleDeleteMovie = {
                let alertController = UIAlertController(title: "Are you sure delete this from Favourites", message: "", preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                    if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                        let context = appdelegate.persistentContainer.viewContext
                        let favouriteToDelete = self.favourites[indexPath.row]
                        context.delete(favouriteToDelete)
                        appdelegate.saveContext()
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(deleteAction)
                self.present(alertController, animated: true, completion: nil)
            }
            //-------------------------------------------------------
            return cell
        }
    //---------------------------------------------------------
    
    // MARK: - NSFetchedResultsControllerDelegate methods
       
       func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           tableView.beginUpdates()
       }
       
       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
           
           switch type {
           case .insert:
               if let newIndexPath = newIndexPath {
                   tableView.insertRows(at: [newIndexPath], with: .fade)
               }
           case .delete:
               if let indexPath = indexPath {
                   tableView.deleteRows(at: [indexPath], with: .fade)
               }
           case .update:
               if let indexPath = indexPath {
                   tableView.reloadRows(at: [indexPath], with: .fade)
               }
           default:
               tableView.reloadData()
           }
           
           if let fetchedObjects = controller.fetchedObjects {
               favourites = fetchedObjects as! [Fav_Mov_MO]
           }
       }

       func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
           tableView.endUpdates()
       }
    // End of Updates if it Happened
    // prepare segue for sending data of object to Detail View Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show" {
           
            if let indexPath = tableView.indexPathForSelectedRow {
                if let destinationController = segue.destination as? DetailViewController {
                    destinationController.backDropPath = favourites[indexPath.row].backDrop_image!
                    destinationController.MovieName = favourites[indexPath.row].movie_name!
                    destinationController.summary = favourites[indexPath.row].summary!
                    destinationController.ReleaseDate = favourites[indexPath.row].release_date!
                    destinationController.rate = favourites[indexPath.row].rating!
                    destinationController.PosterPath = favourites[indexPath.row].poster_image!
                    tableView.deselectRow(at: indexPath, animated: false)
                }}}}
    //End of Prepartion-------------------------------------------
}

