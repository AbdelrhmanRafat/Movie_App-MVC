//
//  DetailViewController.swift
//  Movies_App_Intern
//
//  Created by Macbook on 08/02/2021.
//

import UIKit
import CoreData
class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
   
    // Initializations
    @IBOutlet var BackDrop_Image : UIImageView!
    @IBOutlet var fav_button : UIButton!
    @IBOutlet var tableView : UITableView!
    var MovieName : String = ""
    var rate : String = ""
    var ReleaseDate : String = ""
    var summary : String = ""
    var backDropPath = ""
    var PosterPath = ""
    var chk_fav : Bool?
    var favourites : [Fav_Mov_MO] = [] // Array Catch Data of Core Data And Display it
    var fav : Fav_Mov_MO! // An instance of Core Data in order to Catch object
    var fetchResultsController: NSFetchedResultsController<Fav_Mov_MO>!
    // End of Initializations
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BackDrop_Image.downloaded(from: backDropPath) //Display the BackDrop Image
        // Customize Appearance of Table View
        tableView.separatorStyle = .none
        tableView.contentInsetAdjustmentBehavior = .never
        // End Customize of Table View ---------------
        navigationController?.navigationBar.tintColor = .white // make backButton Color white
        // Start Fetching Data From Core Data And Put it in favourites Array
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
                    favourites = fetchedobject}}
            catch {
                print(error)
            }}
        // End Fetching Data From Core Data in favourites Array----------
    }
    // Start Take Descision either object is in Core Data or not
    override func viewWillAppear(_ animated: Bool) {
        for favourite in favourites {
            if MovieName == favourite.movie_name {
                chk_fav = favourite.is_fav
                break
            }}
        if chk_fav == nil {
            if let image = UIImage(systemName: "heart"){
                fav_button.setImage(image, for: .normal)}
        }
        else {
            if chk_fav! {
                if let image = UIImage(systemName: "heart.fill"){
                    fav_button.setImage(image, for: .normal)}
            }
            else {
                    if let image = UIImage(systemName: "heart"){
                        fav_button.setImage(image, for: .normal)}
            }}}
    // ----------------------------------------------------
    
    /* Make the Movie object either favourite or not if it's not-Liked save to core data
    if it's already Liked Delete it from Core Data
    */
    @IBAction func Tapped_fav(_ sender: Any) {
        switch chk_fav {
        case false:
                  if let image = UIImage(systemName: "heart.fill"){
                    fav_button.setImage(image, for: .normal)}
                    chk_fav = true
            if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                            let favourite = Fav_Mov_MO(context: appdelegate.persistentContainer.viewContext)
                favourite.movie_name = MovieName
                favourite.is_fav = true
                favourite.poster_image = PosterPath
                favourite.backDrop_image = backDropPath
                favourite.rating = rate
                favourite.release_date = ReleaseDate
                favourite.summary = summary
                appdelegate.saveContext()
                        }
        case true:
               if let image = UIImage(systemName: "heart"){
                    fav_button.setImage(image, for: .normal)}
                    chk_fav = false
            if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                           let context = appdelegate.persistentContainer.viewContext
                for favourite in favourites {
                    if MovieName == favourite.movie_name {
                        fav = favourite
                        break
                    }}
                guard let indexpath = self.fetchResultsController.indexPath(forObject: fav) else { return }
                let favouriteToDelete = self.fetchResultsController.object(at: indexpath)
                           context.delete(favouriteToDelete)
                           appdelegate.saveContext()
                       }
        case nil:
            if let image = UIImage(systemName: "heart.fill"){
                   fav_button.setImage(image, for: .normal)}
                   chk_fav = true
            if let appdelegate = (UIApplication.shared.delegate as? AppDelegate){
                            let favourite = Fav_Mov_MO(context: appdelegate.persistentContainer.viewContext)
                favourite.movie_name = MovieName
                favourite.is_fav = true
                favourite.poster_image = PosterPath
                favourite.backDrop_image = backDropPath
                favourite.rating = rate
                favourite.release_date = ReleaseDate
                favourite.summary = summary
                appdelegate.saveContext()
                        }
        default:
            print("Error")
        }}
    // -------------------------------------------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    /* Func Used To Display Data of Movie in Table View Cell 0 for Movie Detail poster,name
     ,Rate and Release Date. Cell 1 Used to Display The Summary of the Movie
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MD") as! MovieDetailsTableViewCell
            cell.Name.text = MovieName
            cell.Rate.text = rate
            cell.Release_Data.text = ReleaseDate
            cell.Poster_Image.downloaded(from: PosterPath)
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "D") as! DescriptionTableViewCell
            cell.Description.text = summary
            cell.selectionStyle = .none
            return cell
        default:
                fatalError("Failed to instantiate the table view cell for detail view controller")
        }}
    //---------------------------------------------------------
    // Func Used to Update Core Data When Any Action Got Happen either Save Action or Delete Action
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let fetchedObjects = controller.fetchedObjects {
            favourites = fetchedObjects as! [Fav_Mov_MO]
        }}
    //------------------------------------------------------
}
