//
//  Environment.swift
//  App Lodjinha
//
//  Created by Matheus on 17/05/22.
//

import Foundation

struct Lodjinha {
    static let baseURL: String = "https://alodjinha.herokuapp.com"
    
    enum Product: String {
        case GET
        case GET_MORE_SOLD
        case GET_OR_POST
        
        func value() -> String{
            switch self {
                case .GET:
                    return "https://alodjinha.herokuapp.com/produto"
                case .GET_MORE_SOLD:
                    return "https://alodjinha.herokuapp.com/produto/maisvendidos"
                case .GET_OR_POST:
                    return "https://alodjinha.herokuapp.com/produto/"
            }
        }
    }
    
    enum Category: String {
        case GET
        
        func value() -> String{
            switch self {
                case .GET:
                    return "https://alodjinha.herokuapp.com/categoria"
            }
        }
    }
    
    enum Banner: String {
        case GET
        
        func value() -> String{
            switch self {
                case .GET:
                    return "https://alodjinha.herokuapp.com/banner"
            }
        }
    }
}

