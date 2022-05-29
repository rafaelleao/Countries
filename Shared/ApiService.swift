//
//  ApiService.swift
//  Countries
//
//  Created by Rafael Leão on 27.05.22.
//

import Foundation

struct RuntimeError: Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    public var localizedDescription: String {
        message
    }
}

class ApiService {

    private let baseUrl = "https://restcountries.com/v3.1/"

    func loadCountries() async throws -> [Country] {
        try await request(parameter: "all")
    }

    func searchLanguage(_ language: String) async throws -> [Country] {
        try await request(parameter: "lang/\(language)")
    }

    func searchCountryCode(_ code: String) async throws -> [Country] {
        try await request(parameter: "alpha/\(code)")
    }

    func searchCurrency(_ code: String) async throws -> [Country] {
        try await request(parameter: "currency/\(code)")
    }

    private func request(parameter: String) async throws -> [Country] {
        guard let url = URL(string: baseUrl + parameter) else {
            throw RuntimeError("Invalid URL")
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let objects = try JSONDecoder().decode([Country].self, from: data)
            return objects
        } catch {
            print(error)
            throw error
        }
    }
}
