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
struct Country: Decodable {
    let name: Name
    let flag: String?
    //let fifa: String
}
/*
extension Country: Identifiable {
    var id: ObjectIdentifier {
        ObjectIdentifier(fifa.hashValue)
    }
}

*/
