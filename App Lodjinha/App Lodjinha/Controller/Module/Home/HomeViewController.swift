//
//  HomeViewController.swift
//  App Lodjinha
//
//  Created by Matheus on 16/05/22.
//

import UIKit
import iCarousel

class HomeViewController: UIViewController{
    
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bannersICarousel: iCarousel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    let goToSubmarino: String = "https://www.submarino.com.br/"
    
    var imageUrls: [String] = []
    var categoriesViewModel: [CategoryViewModel?] = []
    
    let networkManager: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannersICarousel.delegate = self
        bannersICarousel.dataSource = self
        bannersICarousel.bounces = false
        
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        
        self.categoriesCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        
        self.loadAllHomeViewDependencies()
        self.setHomeViewAppearance()
    }
    
    func setHomeViewAppearance(){
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logoNavbar_2")!)
    }
    
    func loadAllHomeViewDependencies() {
        self.networkManager.fetchBanners(onComplete: { [weak self] urls in
            guard let self = self else { return }
            self.imageUrls = urls
            self.bannersICarousel.reloadData()
            
            self.pageControl.numberOfPages = self.imageUrls.count
            self.pageControl.currentPage = 0
            
            self.loadingIcon.stopAnimating()
            self.loadingIcon.isHidden = true
        })
        
        self.networkManager.fetchCategories { [weak self] categories in
            guard let self = self else { return }
            self.categoriesViewModel = categories
            self.categoriesCollectionView.reloadData()
        }
        
    }
}
extension HomeViewController: iCarouselDelegate, iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
        self.imageUrls.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let imageView = UIImageView()
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let imageURL = URL(string: self.imageUrls[index]) {
                if let data = try? Data(contentsOf: imageURL){
                    DispatchQueue.main.async {
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
        imageView.frame = bannersICarousel.frame
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        if let url = URL(string: self.goToSubmarino) {
            UIApplication.shared.open(url)
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        self.pageControl.currentPage = carousel.currentItemIndex
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categoriesViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoriesCollectionViewCell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionViewCell", for: indexPath) as! CategoriesCollectionViewCell
        
        if let category: CategoryViewModel = self.categoriesViewModel[indexPath.row] {
            
            cell.categorieLabelName.text = category.descricao
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let imageURL = URL(string: category.urlImagem!) {
                    if let data = try? Data(contentsOf: imageURL){
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            cell.categorieImageView.image = image
                        }
                    }
                }
            }
            
        }
        
        return cell
    }
    
}
