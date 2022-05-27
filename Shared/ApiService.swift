//
//  ApiService.swift
//  Countries
//
//  Created by Rafael Leão on 27.05.22.
//

import Foundation

class ApiService {

    func loadCountries() async throws -> [Country] {
        let url = URL(string: "https://restcountries.com/v3.1/all")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let objects = try JSONDecoder().decode([Country].self, from: data)
        return objects
    }
}
