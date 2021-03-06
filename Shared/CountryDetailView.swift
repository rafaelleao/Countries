//
//  CountryDetailView.swift
//  Countries
//
//  Created by Rafael Leão on 28.05.22.
//

import SwiftUI

struct CountryDetailView<ViewModel>: View where ViewModel: CountryDetailViewModel {
    @ObservedObject
    var viewModel: ViewModel

    var body: some View {
        VStack {
            flagImage
            list
        }
    #if os(iOS)
        .navigationBarTitle(viewModel.title, displayMode: .inline)
    #else
        .navigationTitle(viewModel.title)
    #endif
    }

    var flagImage: some View {
        AsyncImage(url: viewModel.flagURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .shadow(radius: 10)
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: 120, maxHeight: 120)
    }

    var list: some View {
        List {
            ForEach(viewModel.sections, id: \.title) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.values, id: \.value) { value in
                        if let navigationLink = value.navigationLink  {
                            NavigationLink(destination: {
                                navigationLink
                            }) {
                                Text(value.value)
                            }
                        } else {
                            Text(value.value)
                        }
                    }
                }
            }
        }
    }
}

struct DynamicCountryDetailView: View {
    @ObservedObject
    var viewModel: DynamicCountryDetailViewModel

    var body: some View {
        CountryDetailView<DynamicCountryDetailViewModel>(viewModel: viewModel)
            .onAppear {
                viewModel.load()
            }
    }
}

struct CountryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailView(viewModel: StaticCountryDetailViewModel(country: TestData.brazil))
    }
}
