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
        
        let accessoryImage = UIImage(systemName: "chevron.right")
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:(accessoryImage?.size.width)!, height:(accessoryImage?.size.height)!));
        checkmark.image = accessoryImage
        checkmark.tintColor = .purple
        self.accessoryView = checkmark
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        self.productImage.image = UIImage()
        self.productName.text = ""
        self.productDescription.text = ""
        self.productPrice.text = ""
        self.productLastPrice.text = ""
        
    }
    
    func setup(productVM: ProductsViewModel) {
        if let nome = productVM.nome, let descricao = productVM.descricao, let urlImagem = productVM.urlImagem, let precoPor = productVM.precoPor, let precoDe = productVM.precoDe {

            self.productName.text = nome
            self.productDescription.text = descricao
            
            let attributedPriceDe = NSAttributedString(string: String(format: "De: %.2f", precoDe), attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            self.productLastPrice.attributedText = attributedPriceDe
            
            self.productPrice.text = String(format: "Por: %.2f", precoPor)
            
            self.productImage.kf.setImage(with: URL(string: urlImagem), placeholder: UIImage(named: "imagenotfound"))
            
        }
    }
    
}
