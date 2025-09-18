//
//  ContentView.swift
//  BasketBallApp
//
//  Created by Shubham Deshmukh on 18/09/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ScheduleViewModel()

    var body: some View {
        NavigationView {
            Group {
                if let error = vm.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List {
                        ForEach(vm.gamesByMonth, id: \.monthName) { section in
                            Section(header: Text(section.monthName).font(.headline)) {
                                ForEach(section.games) { game in
                                    GameRowView(game: game)
                                        .listRowBackground(Color(UIColor.systemGray6))
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Schedule")
        }
    }
}


#Preview {
    ContentView()
}
