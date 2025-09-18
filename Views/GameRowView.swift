//
//  GameRowView.swift
//  BasketBallApp
//
//  Created by Shubham Deshmukh on 18/09/25.
//

import SwiftUI

struct GameRowView: View {
    let game: GameViewModel

    var body: some View {
        HStack(alignment: .center) {
            // Visitor team (left)
            TeamView(abbr: game.visitorAbbr,
                     name: game.visitorName ?? "",
                     logoURL: game.visitorLogo)

            Spacer()

            // Middle: status / time / arena
            VStack(spacing: 6) {
                if game.st == 2 {
                    Text("LIVE")
                        .font(.caption2).bold()
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                } else if game.st == 3 {
                    Text(game.stt ?? "Final")
                        .font(.subheadline).bold()
                } else {
                    Text(game.stt ?? formattedTime(date: game.date))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text("\(game.visitorAbbr)  VS  \(game.homeAbbr)")
                    .font(.caption).bold()

                if let arena = game.arena, !arena.isEmpty {
                    Text(arena)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .multilineTextAlignment(.center)
            .frame(minWidth: 140)

            Spacer()

            // Home team (right)
            TeamView(abbr: game.homeAbbr,
                     name: game.homeName ?? "",
                     logoURL: game.homeLogo)
        }
        .padding(.vertical, 10)
    }

    private func formattedTime(date: Date?) -> String {
        guard let d = date else { return "" }
        let fmt = DateFormatter()
        fmt.dateFormat = "E, d MMM • h:mm a" // e.g. Wed, 7 Jul • 7:30 PM
        return fmt.string(from: d)
    }
}
