//
//  CountryDetailViewModel.swift
//  Countries
//
//  Created by Rafael Leão on 28.05.22.
//

import Foundation

struct CountryDetailSection {
    let title: String
    let values: [String]
}

@MainActor
class CountryDetailViewModel: ObservableObject {

    let country: Country
    let sections: [CountryDetailSection]

    init(country: Country) {
        self.country = country
        self.sections = CountryDetailViewModel.buildSections(country: country)
    }

    var title: String {
        country.name.common
    }

    var flagURL: URL? {
        if let flagURL = country.flags["png"] {
            return URL(string: flagURL)
        }
        return nil
    }

    private static func buildSections(country: Country) -> [CountryDetailSection] {
        var sections = [CountryDetailSection]()
        sections.append(CountryDetailSection(title: "Name", values: [country.name.official]))
        sections.append(CountryDetailSection(title: "Population", values: ["\(country.population)"]))
        if let capital = country.capital?.first {
            sections.append(CountryDetailSection(title: "Capital", values: [capital]))
        }
        sections.append(CountryDetailSection(title: "Region", values: [country.region]))
        if let subregion = country.subregion {
            sections.append(CountryDetailSection(title: "Subregion", values: [subregion]))
        }
        if let languages = country.languages {
            sections.append(CountryDetailSection(title: "Languages", values: languages.values.reversed()))
        }
        return sections
    }
}
