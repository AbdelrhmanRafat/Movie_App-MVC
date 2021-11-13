//
//  FavouriteTableViewCell.swift
//  Movies_App_Intern
//
//  Created by Macbook on 08/02/2021.
//

import UIKit
import CoreData
  

class FavouriteTableViewCell: UITableViewCell, NSFetchedResultsControllerDelegate {
    
    var handleDeleteMovie: (()->())?
    var fetchResultsController: NSFetchedResultsController<Fav_Mov_MO>!
    @IBOutlet weak var Name: UILabel!{
        didSet{
            Name.numberOfLines = 0
        }
    }
    @IBOutlet weak var Rate: UILabel!{
        didSet{
            Rate.numberOfLines = 0
        }
    }
    @IBOutlet weak var Release_Data: UILabel!{
        didSet{
            Release_Data.numberOfLines = 0
        }
    }
    @IBOutlet var Poster_Image : UIImageView!
   
    @IBAction func Delete_Button(_ sender: Any) {
        handleDeleteMovie?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
