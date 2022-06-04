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
    
    
    func fetchProducts(url: String, onComplete: @escaping ([ProductsViewModel]) -> Void){
        AF.request(url, method: .get).response { response in
            switch response.result {
                case .success(let response):
                    if let products = self.parsingProductsJSON(with: response!) {
                        onComplete(products.data.map({
                            ProductsViewModel(id: $0.id, descricao: $0.descricao, nome: $0.nome, precoDe: $0.precoDe, precoPor: $0.precoPor, urlImagem: $0.urlImagem)
                        }))
                    }
                case .failure(let error):
                    print("\(error)")
            }
        }
    }
    
    func parsingProductsJSON(with data: Data) -> ProductsData? {
        do {
            let products = try JSONDecoder().decode(ProductsData.self, from: data)
            return products
        }catch{
            print(error)
            return nil
        }
    }
    
    func parsingBannerJSON(with data: Data) -> BannersData?{
        do {
            let banners = try JSONDecoder().decode(BannersData.self, from: data)
            return banners
        }catch{
            print(error)
            return nil
        }
    }
    
    func parsingCategoriesJSON(with data: Data) -> CategoriesData? {
        do{
            let categories = try JSONDecoder().decode(CategoriesData.self, from: data)
            return categories
        }catch{
            print(error)
            return nil
        }
    }
    
}

