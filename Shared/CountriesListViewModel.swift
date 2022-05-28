//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by Rafael Leão on 26.05.22.
//

import Foundation

@MainActor
class CountriesListViewModel: ObservableObject {

    private var countries: [Country] = [] {
        didSet {
            filter()
        }
    }
    let apiService = ApiService()

    @Published
    var results: [Country] = []

    var searchString: String = "" {
        didSet {
            filter()
        }
    }

    func loadData() async {
        if let objects = try? await apiService.loadCountries() {
            countries = objects
        }
    }

    func filter() {
        Task(priority: .low) {
            if searchString.isEmpty {
                results = countries
            } else {
                results = countries.filter({ country in
                    country.name.official.contains(searchString)
                })
            }
        }
    }
}
