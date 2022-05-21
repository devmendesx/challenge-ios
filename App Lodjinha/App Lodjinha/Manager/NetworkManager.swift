//
//  APIManager.swift
//  App Lodjinha
//
//  Created by Matheus on 17/05/22.
//

import Foundation
import Alamofire


class NetworkManager {

    func fetchBanners(onComplete: @escaping ([String]) -> Void){
        AF.request(Lodjinha.Banner.GET.value(), method: .get).response { response in
            switch response.result {
                case .success(let response):
                    if let banners = self.parsingBannerJSON(with: response!) {
                        onComplete(banners.data.map({$0.urlImagem}))
                    }
                case .failure(let error):
                    print("\(error)")
            }
        }
    }
    
    
    func fetchCategories(onComplete: @escaping ([CategoryViewModel]) -> Void){
        AF.request(Lodjinha.Category.GET.value(), method: .get).response { response in
            switch response.result {
                case .success(let response):
                    if let categories = self.parsingCategoriesJSON(with: response!) {
                        onComplete(categories.data.map({CategoryViewModel(descricao: $0.descricao, urlImagem: $0.urlImagem)}))
                    }
                case .failure(let error):
                    print("\(error)")
            }
        }
    }
    
    func parsingBannerJSON(with data: Data) -> BannersData?{
        do {
            let viewModel = try JSONDecoder().decode(BannersData.self, from: data)
            return viewModel
        }catch{
            print(error)
            return nil
        }
    }
    
    func parsingCategoriesJSON(with data: Data) -> CategoriesData? {
        do{
            let categoriesViewModel = try JSONDecoder().decode(CategoriesData.self, from: data)
            return categoriesViewModel
        }catch{
            print(error)
            return nil
        }
    }
    
}

