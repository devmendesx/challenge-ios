//
//  Product.swift
//  App Lodjinha
//
//  Created by Matheus on 17/05/22.
//

import Foundation

struct Product: Codable {
    let categoria: Category
    let id: Int
    let descricao: String
    let nome: String
    let precoDe: Double
    let precoPor: Double
    let urlImagem: String
}

struct ProductsData: Codable {
    let data: [Product]
}
