//
//  CountriesList.swift
//  Shared
//
//  Created by Rafael Leão on 26.05.22.
//

import SwiftUI

struct CountriesList: View {

    @ObservedObject
    var viewModel: CountriesListViewModel

    var body: some View {
        list
    #if os(iOS)
            .searchable(text: $viewModel.searchString, placement: .navigationBarDrawer(displayMode: .always))
    #else
            .searchable(text: $viewModel.searchString, placement: .sidebar)
    #endif
        .refreshable {
            await viewModel.loadData()
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
        .navigationTitle("Countries")
    }

    var list: some View {
        List(viewModel.results, id: \.name.common) { country in
            NavigationLink(destination: CountryDetailView(viewModel: StaticCountryDetailViewModel(country: country))) {
                HStack {
                    Text(country.flag ?? "")
                    Text(country.name.common)
                        .bold()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesList(viewModel: PreviewCountriesListViewModel())
    }
}

class PreviewCountriesListViewModel: CountriesListViewModel {
    override init() {
        super.init()
        results = [
            TestData.brazil,
            TestData.mauritius
        ]
    }

    override func loadData() async {
    }
}
