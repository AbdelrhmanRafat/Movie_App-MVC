//
//  ViewController.swift
//  Movies_App_Intern
//
//  Created by Macbook on 06/02/2021.
//

import UIKit
class ViewController: UIViewController {
    
    // Initializations
    @IBOutlet var collectionView : UICollectionView!
    @IBOutlet var NoConnectView : UIView!
    private var results = [Results]() // Array of Struct Results of Codable
    let ImagesUrl = "http://image.tmdb.org/t/p/w185"
    let popular = "popular"
    let top_rated = "top_rated"
    var popular_chk : Bool = true // Boolean Used To check either you are on popular view or not
    var toprated_chk : Bool = false // Boolean Used To check either you are on top_rated view or not
    //End of Initalizations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        // Hide The No Connection View As Default
        collectionView.backgroundView = NoConnectView
        collectionView.backgroundView?.isHidden = true
        // ---------------------------------
        getApi(ApiKey: popular) //Display popularAPi As Default
    }
    //Button in No Connection View Used To Try To get Request on Api And Get it
    @IBAction func TryAgainAction(_ sender: Any) {
        getApi(ApiKey: popular)
    }
    //----------------------------------------------------------
    //Show Menu Button To Choose Either Api You want To display ot going onto Favoutites View
    @IBAction func Show_Menu(_ sender: Any) {
        let alertController = UIAlertController(title: "Choose", message: "Your List", preferredStyle: .actionSheet)
        alertController.modalPresentationStyle = .popover
        let popularAction = UIAlertAction(title: "popular", style: .default) { (action) in
            if !self.popular_chk {
                self.popular_chk = true
                self.toprated_chk = false
                self.getApi(ApiKey: self.popular)
            }
        }
        let top_ratedAction = UIAlertAction(title: "top-rated", style: .default) { (action) in
            if !self.toprated_chk{
                self.toprated_chk = true
                self.popular_chk = false
                self.getApi(ApiKey: self.top_rated)
            }}
        let go_to_favouriteAction = UIAlertAction(title: "Go to Favourites", style: .default) { (action) in
            self.performSegue(withIdentifier: "ShowFav", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(popularAction)
        alertController.addAction(top_ratedAction)
        alertController.addAction(go_to_favouriteAction)
        alertController.addAction(cancelAction)
        addActionSheetForiPad(actionSheet: alertController)
        present(alertController, animated: true, completion: nil)
       }
    //------------------------------------------------------------------
    // Getting Api By Making Request on Url
    func getApi(ApiKey : String) {
        let UrlString =  "https://api.themoviedb.org/3/movie/\(ApiKey)?api_key=6ba7581f4330b87ceabc4ef8212ed72b"
        guard let MovieUrl = URL(string: UrlString) else {
            return
        }
        let Request = URLRequest(url: MovieUrl)
        let task = URLSession.shared.dataTask(with: Request) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                if let jsonResults = try? decoder.decode(ApiData.self, from: data){
                        self.results = jsonResults.results!
                       }
                OperationQueue.main.addOperation {
                    self.collectionView.reloadData()
                }}
        }
        task.resume()
    }}
 //----------------------------------------------------
   
extension ViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if results.count == 0 {
            collectionView.backgroundView?.isHidden = false
            return results.count
        }
        else {
            collectionView.backgroundView?.isHidden = true
            return results.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                layout collectionViewLayout: UICollectionViewLayout,
                sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width / 2), height: 250)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Movie_Poster_Cell", for: indexPath) as! MoviesCollectionViewCell
        guard  let BackDropPath = results[indexPath.row].poster_path else {
            cell.Movie_image.backgroundColor = UIColor.clear
            return cell
        }
        let CompleteUrl = ImagesUrl + BackDropPath
        cell.Movie_image.downloaded(from: CompleteUrl)
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let cell = sender as? UICollectionViewCell,
                let indexPath = self.collectionView.indexPath(for: cell) {
                 
                 let vc = segue.destination as! DetailViewController
                vc.MovieName = results[indexPath.row].title
                vc.rate = String(results[indexPath.row].vote_average ?? 0)
                vc.summary = results[indexPath.row].overview ?? "Error"
                vc.ReleaseDate = results[indexPath.row].release_date ?? "Error"
                if let posterpath = results[indexPath.row].poster_path {
                    vc.PosterPath = ImagesUrl + posterpath
                }
                if let backdropPath = results[indexPath.row].backdrop_path {
                    vc.backDropPath = ImagesUrl + backdropPath
                }}}}
}
