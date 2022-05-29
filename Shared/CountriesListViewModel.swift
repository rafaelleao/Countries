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

    var title: String = "Countries"

    var searchString: String = "" {
        didSet {
            filter()
        }
    }

    var sortButtonImage: String {
        sortedAsc ? "arrow.down.square.fill" : "arrow.up.square.fill"
    }

    func toggleSort() {
        sortedAsc = !sortedAsc
    }

    var sortedAsc = true {
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
            let sorted = sortedAsc ? countries.sorted(by: <) : countries.sorted(by: >)
            if searchString.isEmpty {
                results = sorted
            } else {
                results = sorted.filter({ country in
                    country.name.official.lowercased().contains(searchString.lowercased())
                })
            }
        }
    }
}

@MainActor
class DynamicCountriesListViewModel: CountriesListViewModel {

    let linkType: LinkType

    init(linkType: LinkType, title: String) {
        self.linkType = linkType
        super.init()
        self.title = title
    }

    override func loadData() async {
        switch linkType {
        case .country(_):
            break
        case .language(let language):
            await searchLanguage(language)
        case .currency(code: let code):
            await searchCurrency(code)
        }
    }

    private func searchLanguage(_ language: String) async {
        if let result = try? await apiService.searchLanguage(language) {
            countries = result
        }
    }

    private func searchCurrency(_ code: String) async {
        if let result = try? await apiService.searchCurrency(code) {
            countries = result
        }
    }
}
