//
//  CommentTableViewCell.swift


import Foundation
import UIKit

class CommentTableViewCell: UITableViewCell{
    
    let globalColor = UIColor(red: 77/255, green: 80/255, blue: 97/255, alpha: 1.0)
    
    @IBOutlet weak var commentTitle: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
        
        backgroundColor = globalColor
        commentTitle.textColor = .white
            // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
    }

    
    

}
