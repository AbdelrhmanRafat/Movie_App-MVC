//
//  DescriptionTableViewCell.swift
//  Movies_App_Intern
//
//  Created by Macbook on 07/02/2021.
//

import UIKit

class DescriptionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var Description: UILabel!{
        didSet{
            Description.numberOfLines = 0
        }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
