//
//  CountriesListViewModel.swift
//  Countries
//
//  Created by Rafael Leão on 26.05.22.
//

import Foundation

@MainActor
class CountriesListViewModel: ObservableObject {

    @Published
    var countries: [Country] = []

    let apiService = ApiService()

    func loadData() async {
        if let objects = try? await apiService.loadCountries() {
            countries = objects
        }
    }

}
