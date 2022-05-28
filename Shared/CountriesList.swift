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
        NavigationView {
            List(viewModel.countries, id: \.name.common) { country in

                NavigationLink(destination: CountryDetailView(viewModel: CountryDetailViewModel(country: country))) {
                    HStack {
                        Text(country.flag ?? "")
                        Text(country.name.common)
                            .bold()
                    }                }


            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.top)

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
            TestData.brazil,
            TestData.mauritius
        ]
    }

    override func loadData() async {

    }
}
