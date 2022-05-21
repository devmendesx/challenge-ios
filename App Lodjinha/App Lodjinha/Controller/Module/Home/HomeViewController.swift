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
    @IBOutlet weak var bestSellerTableView: UITableView!
    
    let goToSubmarino: String = "https://www.submarino.com.br/"
    
    var imageUrls: [String] = []
    var categoriesViewModel: [CategoryViewModel?] = []
    var productsViewModel: [ProductsViewModel?] = []
    
    let networkManager: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bannersICarousel.delegate = self
        self.bannersICarousel.dataSource = self
        self.bannersICarousel.bounces = false
        
        self.categoriesCollectionView.delegate = self
        self.categoriesCollectionView.dataSource = self
        
        self.bestSellerTableView.delegate = self
        self.bestSellerTableView.dataSource = self
        self.categoriesCollectionView.register(UINib(nibName: "CategoriesCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "CategoriesCollectionViewCell")
        
        self.bestSellerTableView.register(UINib(nibName: "BestSellerTableViewCell", bundle: .main), forCellReuseIdentifier: "BestSellerTableViewCell")
        
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
        
        self.networkManager.fetchProducts(url: Lodjinha.Product.GET_MORE_SOLD.value()) { [weak self] products in
            guard let self = self else { return }
            
            self.productsViewModel = products
            self.bestSellerTableView.reloadData()
            self.bestSellerTableView.bounces = false
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
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let imageURL = URL(string: category.urlImagem!) {
                    if let data = try? Data(contentsOf: imageURL){
                        DispatchQueue.main.async {
                            let image = UIImage(data: data)
                            cell.categorieImageView.image = image
                            cell.categorieLabelName.text = category.descricao
                        }
                    }
                }
            }
            
        }
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.productsViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BestSellerTableViewCell = bestSellerTableView.dequeueReusableCell(withIdentifier: "BestSellerTableViewCell", for: indexPath) as! BestSellerTableViewCell
        
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = cell.bounds
        cell.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        if let product: ProductsViewModel = self.productsViewModel[indexPath.row] {
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                if let nome = product.nome, let descricao = product.descricao, let urlImagem = product.urlImagem, let precoPor = product.precoPor, let precoDe = product.precoDe {

                    if let imageURL = URL(string: urlImagem) {
                        if let data = try? Data(contentsOf: imageURL){
                            DispatchQueue.main.async {
                                let image: UIImage? = UIImage(data: data)
                                cell.productImage.image = image
                                cell.productName.text = nome
                                cell.productDescription.text = descricao
                                cell.productLastPrice.text = String(format: "R$ %.2f", precoDe)
                                cell.productPrice.text = String(format: "R$ %.2f", precoPor)
                            }
                        }
                    }
                }
            }
            
            
        }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        return cell
    }
    
    
}
