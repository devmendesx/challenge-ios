//
//  CategoriesCollectionViewCell.swift
//  App Lodjinha
//
//  Created by Matheus on 20/05/22.
//

import UIKit
import Kingfisher

class CategoriesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var categorieImageView: UIImageView!
    @IBOutlet weak var categorieLabelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.categorieLabelName.text = ""
        self.categorieImageView.image = UIImage()
    }
    
    func setup(categoryVM: CategoryViewModel) {
        self.categorieLabelName.text = categoryVM.descricao
        self.categorieImageView.kf.setImage(with: URL(string: categoryVM.urlImagem!), placeholder: UIImage(named: "imagenotfound"))
    }

}
