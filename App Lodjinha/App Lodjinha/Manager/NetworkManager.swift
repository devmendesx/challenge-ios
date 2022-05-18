//
//  APIManager.swift
//  App Lodjinha
//
//  Created by Matheus on 17/05/22.
//

import Foundation
import Alamofire


class NetworkManager {
    
    var onComplete: (([String]) -> Void)?
    
    func fetchBanners(onComplete: @escaping ([String]) -> Void){
        self.onComplete = onComplete
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
    
    func parsingBannerJSON(with data: Data) -> BannersData?{
        do {
            let viewModel = try JSONDecoder().decode(BannersData.self, from: data)
            return viewModel
        }catch{
            print(error)
            return nil
        }
    }
}

