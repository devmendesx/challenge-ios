//
//  Category.swift
//  App Lodjinha
//
//  Created by Matheus on 17/05/22.
//

import Foundation

struct Category: Codable {
    let id: Int
    let descricao: String
    let urlImagem: String
}

struct CategoriesData: Codable {
    let data: [Category]
}

