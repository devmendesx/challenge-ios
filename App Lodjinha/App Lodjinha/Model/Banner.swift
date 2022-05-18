//
//  Banner.swift
//  App Lodjinha
//
//  Created by Matheus on 17/05/22.
//

import Foundation

struct Banner: Codable {
    let id: Int
    let linkUrl: String
    let urlImagem: String
}

struct BannersData: Codable {
    let data: [Banner]
}
