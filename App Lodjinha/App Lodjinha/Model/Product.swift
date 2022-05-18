//
//  Product.swift
//  App Lodjinha
//
//  Created by Matheus on 17/05/22.
//

import Foundation

struct Product: Codable {
    let id: Int
    let descricao: String
    let nome: String
    let precoDe: Double
    let precoPor: Double
    let urlImagem: String
}

struct ProductsData: Codable {
    let products: [Product]
    let offset: Int
    let total: Int
}
