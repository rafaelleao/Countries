//
//  CountryDetailViewModel.swift
//  Countries
//
//  Created by Rafael Leão on 28.05.22.
//

import Foundation
import SwiftUI

enum LinkType {
    case country(code: String)
    case language(language: String)
    case currency(code: String)
}

struct CountryDetailSection {
    let title: String
    let values: [CountryDetailSectionValue]
}

struct CountryDetailSectionValue {
    let value: String
    let navigationLink: AnyView?

    init(_ value: String, navigationLink: AnyView? = nil) {
        self.value = value
        self.navigationLink = navigationLink
    }
}


@MainActor
protocol CountryDetailViewModel: ObservableObject {

    var title: String { get }
    var flagURL: URL? { get }
    var sections: [CountryDetailSection] { get }
}

class DynamicCountryDetailViewModel: CountryDetailViewModel {
    let linkType: LinkType
    let apiService = ApiService()

    init(linkType: LinkType) {
        self.linkType = linkType
    }

    var title: String = ""

    var flagURL: URL?

    var sections: [CountryDetailSection] = []

    func load() {
        Task {
            switch linkType {
            case .country(let code):
                let results = try await apiService.searchCountryCode(code)
                if let country = results.first {
                    update(country: country)
                }
            default:
                break
            }
        }
    }

    private func update(country: Country) {
        title =  country.name.common
        sections = SectionBuilder().buildSections(country: country)
        if let urlString = country.flags["png"] {
            flagURL = URL(string: urlString)
        }
        objectWillChange.send()
    }
}

class StaticCountryDetailViewModel: CountryDetailViewModel {

    let country: Country
    let sections: [CountryDetailSection]

    init(country: Country) {
        self.country = country
        self.sections = SectionBuilder().buildSections(country: country)
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
}

@MainActor
struct SectionBuilder {
    func buildSections(country: Country) -> [CountryDetailSection] {
        var sections = [CountryDetailSection]()
        sections.append(CountryDetailSection(title: "Name", values: [CountryDetailSectionValue(country.name.official)]))
        sections.append(CountryDetailSection(title: "Population", values: [CountryDetailSectionValue(String(country.population))]))
        if let capital = country.capital?.first {
            let section = CountryDetailSection(title: "Capital", values: [CountryDetailSectionValue(capital)])
            sections.append(section)
        }
        sections.append(CountryDetailSection(title: "Region", values: [CountryDetailSectionValue(country.region)]))
        if let subregion = country.subregion {
            let section = CountryDetailSection(title: "Subregion", values: [CountryDetailSectionValue(subregion)])
            sections.append(section)
        }
        if let languages = country.languages {
            let values: [CountryDetailSectionValue] = languages.values.map { language in
                let viewModel = DynamicCountriesListViewModel(linkType: .language(language: language), title: "\(language) speaking countries")
                let view = AnyView(CountriesList(viewModel: viewModel))
                return CountryDetailSectionValue(language, navigationLink: view)
            }
            sections.append(CountryDetailSection(title: "Languages", values: values))
        }

        if let currencies = country.currencies {
            //for (code, currency) in currencies.enumerated() {
            var values: [CountryDetailSectionValue] = []
            for (code, currency) in currencies {
                let viewModel = DynamicCountriesListViewModel(linkType: .currency(code: code), title: currency.name)
                let view = AnyView(CountriesList(viewModel: viewModel))
                var title = currency.name
                if let symbol = currency.symbol {
                    title += " (\(symbol))"
                }
                values.append(CountryDetailSectionValue(title, navigationLink: view))
            }
            sections.append(CountryDetailSection(title: "Currencies", values: values))
        }
        if let borders = country.borders {
            let values: [CountryDetailSectionValue] = borders.map { border in
                let view = AnyView(DynamicCountryDetailView(viewModel: DynamicCountryDetailViewModel(linkType: .country(code: border))))
                return CountryDetailSectionValue(border, navigationLink: view)
            }
            sections.append(CountryDetailSection(title: "Borders", values: values))
        }

        return sections
    }
}
