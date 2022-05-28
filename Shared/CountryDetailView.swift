//
//  CountryDetailView.swift
//  Countries
//
//  Created by Rafael Leão on 28.05.22.
//

import SwiftUI

struct CountryDetailView: View {
    @ObservedObject
    var viewModel: CountryDetailViewModel

    var body: some View {
        VStack {
        AsyncImage(url: viewModel.flagURL) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
            .shadow(radius: 10)
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 120, maxHeight: 120)

        List {
            ForEach(viewModel.sections, id: \.title) { section in
                Section(header: Text(section.title)) {
                    ForEach(section.values, id: \.self) { value in
                        Text(value)
                    }
                }
            }
        }
        }.navigationBarTitle(viewModel.title, displayMode: .inline)
    }
}

struct CountryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailView(viewModel: CountryDetailViewModel(country: TestData.brazil))
    }
}
