//
//  BestSellerTableViewCell.swift
//  App Lodjinha
//
//  Created by Matheus on 21/05/22.
//

import UIKit

class BestSellerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    @IBOutlet weak var productLastPrice: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
