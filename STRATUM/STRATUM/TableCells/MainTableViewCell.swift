//
//  MainTableViewCell.swift


import UIKit

class MainTableViewCell: UITableViewCell {

  
    let globalColor = UIColor(red: 77/255, green: 80/255, blue: 97/255, alpha: 1.0)
    
    @IBOutlet weak var tableTitle: UILabel!
    @IBOutlet weak var tableTag: UILabel!
    
    override func awakeFromNib() {
          super.awakeFromNib()
        backgroundColor = globalColor
        tableTitle.backgroundColor = globalColor
        tableTag.backgroundColor = globalColor
        tableTitle.textColor = .white
        tableTag.textColor = .systemGray4
        
        
          // Initialization code
      }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
