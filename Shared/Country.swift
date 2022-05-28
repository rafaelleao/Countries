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

    //let fifa: String
}
/*
extension Country: Identifiable {
    var id: ObjectIdentifier {
        ObjectIdentifier(fifa.hashValue)
    }
}

*/
