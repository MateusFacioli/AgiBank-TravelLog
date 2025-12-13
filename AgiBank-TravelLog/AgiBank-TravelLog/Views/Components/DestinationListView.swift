//
//  DestinationListView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 12/12/25.
//

import SwiftUI

struct DestinationListView: View {
    let destinations: [TravelDestination]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(destinations) { destination in
                    DestinationCardView(
                        destination: destination,
                        onFavoriteTapped: {
                            //MARK: TODO Ação de favoritar
                            print("Favoritar: \(destination.name)")
                        },
                        onShareTapped: {
                            //MARK: TODO Ação de compartilhar
                            print("Compartilhar: \(destination.name)")
                        }
                    )
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
    }
}
