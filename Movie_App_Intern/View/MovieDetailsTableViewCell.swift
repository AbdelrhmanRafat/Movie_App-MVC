//
//  MovieDetailsTableViewCell.swift
//  Movies_App_Intern
//
//  Created by Macbook on 07/02/2021.
//

import UIKit

class MovieDetailsTableViewCell: UITableViewCell {
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
     
    }

}
