//
//  TestData.swift
//  Countries
//
//  Created by Rafael Leão on 28.05.22.
//

import Foundation

class TestData {
    static var brazil: Country {
        guard let url = Bundle.main.url(forResource: "brazil", withExtension: "json"),
              let data = try? Data(contentsOf: url, options: .mappedIfSafe),
              let object = try? JSONDecoder().decode(Country.self, from: data) else {
            fatalError()
       }
        return object
    }

    static var mauritius: Country {
        guard let url = Bundle.main.url(forResource: "mauritius", withExtension: "json"),
              let data = try? Data(contentsOf: url, options: .mappedIfSafe),
              let object = try? JSONDecoder().decode(Country.self, from: data) else {
            fatalError()
       }
        return object
    }
}
