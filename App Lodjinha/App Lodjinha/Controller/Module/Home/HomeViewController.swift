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
    
    let goToSubmarino: String = "https://www.submarino.com.br/"
    
    var imageUrls: [String] = []
    let networkManager: NetworkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannersICarousel.delegate = self
        bannersICarousel.dataSource = self
        bannersICarousel.bounces = false
        self.load()
        self.setHomeViewAppearance()
    }
    
    func setHomeViewAppearance(){
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "logoNavbar_2")!)
    }
    
    func load() {
        self.networkManager.fetchBanners(onComplete: { [weak self] urls in
            guard let self = self else { return }
            self.imageUrls = urls
            self.bannersICarousel.reloadData()
            
            self.pageControl.numberOfPages = self.imageUrls.count
            self.pageControl.currentPage = 0
            
            self.loadingIcon.stopAnimating()
            self.loadingIcon.isHidden = true
        })
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
