//
//  CountriesApp.swift
//  Shared
//
//  Created by Rafael Leão on 26.05.22.
//

import SwiftUI

@main
struct CountriesApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                CountriesList(viewModel: CountriesListViewModel())
            }
                .edgesIgnoringSafeArea(.top)
                .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
