//
//  MainView.swift.swift
//  Getaround-test
//
//  Created by Jaouher  on 20/06/2024.
//

import SwiftUI
import CoreData

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    @FetchRequest(
        entity: Favorites.entity(),
        sortDescriptors: [NSSortDescriptor(key: "carId", ascending: true)]
      ) var items: FetchedResults<Favorites>
    
    var body: some View {
        NavigationView {
            if let cars = viewModel.cars {
                List {
                    ForEach(cars) { car in
                        ZStack {
                            listItem(car: car)
                            NavigationLink(destination: CarDetailsView(viewModel: CarDetailsViewModel(car: car))) {
                                EmptyView()
                            }
                            .opacity(0)
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: ViewSizes.small.rawValue)
                            .foregroundColor(.white)
                            .padding(ViewSizes.xSmall.rawValue)
                    )
                }
                .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 0)
                .listStyle(.plain)
                .padding(ViewSizes.small.rawValue)
            }
            else {
                EmptyView()
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchData()
            }
        }
    }
}

extension MainView {
    @ViewBuilder
    func listItem(car: Car) -> some View {
        VStack(alignment: .leading, spacing: ViewSizes.small.rawValue) {
            ZStack(alignment: .topTrailing) {
                if let url = car.pictureURL {
                    GenericImageView(urlString: url)
                        .scaledToFill()
                        .padding(.top, ViewSizes.xSmall.rawValue)
                    FavoriteImage(isLiked: viewModel.isFavorite(car: car, favorites: Array(items)))
                        .padding(ViewSizes.small.rawValue)
                }
            }
            
            HStack(alignment: .top) {
                Text("\(car.brand ?? "") \(car.model ?? "")")
                    .bold()
                Spacer()
                RatingView(isFullRatingView: false,
                           average: car.rating?.average ?? 0,
                           count: car.rating?.count ?? 0)
            }
            Text("**\(car.pricePerDay ?? 0)€** per day")
        }
        .padding(ViewSizes.small.rawValue)
    }
}

#Preview {
    MainView()
}
