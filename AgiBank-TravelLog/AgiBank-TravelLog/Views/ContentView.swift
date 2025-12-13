//
//  ContentView.swift
//  AgiBank-TravelLog
//
//  Created by Mateus Rodrigues on 10/12/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                NavigationLink("Login") {
                    TravelView()
                }
            }
        }
        .navigationTitle("Início")
        .padding()
    }
}

#Preview {
    ContentView()
}
