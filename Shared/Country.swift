//
//  Country.swift
//  Countries
//
//  Created by Rafael Leão on 26.05.22.
//

import Foundation

struct Name: Decodable {
    let common: String
    let official: String
}

enum ImageType: String, Decodable {
    case png
    case svg
}

struct Currency: Decodable {
    let name: String
    let symbol: String?
}

struct Country: Decodable {
    let name: Name
    let flag: String?
    let flags: [String: String]
    let capital: [String]?
    let population: Int
    let languages: [String: String]?
    let borders: [String]?
    let region: String
    let subregion: String?
    let maps: [String: String]
    let currencies: [String: Currency]?
}

extension Country: Comparable {
    static func < (lhs: Country, rhs: Country) -> Bool {
        lhs.name.common < rhs.name.common
    }

    static func == (lhs: Country, rhs: Country) -> Bool {
        lhs.name.common == rhs.name.common
    }
}

