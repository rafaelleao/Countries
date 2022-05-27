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
        List(viewModel.countries, id: \.name.common) { country in
            HStack {
                Text(country.flag ?? "")
                Text(country.name.common)
                    .bold()
            }
        }
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CountriesList(viewModel: PreviewCountriesListViewModel())
    }
}

class PreviewCountriesListViewModel: CountriesListViewModel {
    override init() {
        super.init()
        countries = [
            Country(name: Name(common: "Ghana", official: "Republic of Ghana"), flag: "🇬🇭")
        ]
    }

    override func loadData() async {

    }
}
