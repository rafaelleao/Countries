//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by Rafael Leão on 26.05.22.
//

import Foundation

@MainActor
class CountriesListViewModel: ObservableObject {

    var countries: [Country] = [] {
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
                    country.name.official.lowercased().contains(searchString.lowercased())
                })
            }
        }
    }
}

@MainActor
class DynamicCountriesListViewModel: CountriesListViewModel {

    let linkType: LinkType

    init(linkType: LinkType) {
        self.linkType = linkType
        super.init()
    }

    override func loadData() async {
        switch linkType {
        case .country(let code):
            break
        case .language(let language):
            await searchLanguage(language)
        }
    }

    private func searchLanguage(_ language: String) async {
        if let result = try? await apiService.searchLanguage(language) {
            countries = result
        }
    }
}
