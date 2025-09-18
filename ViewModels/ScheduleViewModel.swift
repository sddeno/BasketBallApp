//
//  ScheduleViewModel.swift
//  BasketBallApp
//
//  Created by Shubham Deshmukh on 18/09/25.
//

import Foundation
import SwiftUI

@MainActor
final class ScheduleViewModel: ObservableObject {
    @Published var gamesByMonth: [(monthName: String, games: [GameViewModel])] = []
    @Published var errorMessage: String?

    private var teamsById: [String: Team] = [:]
    private let appTid = "1610612748" // App team ID

    init() {
        Task {
            await loadAll()
        }
    }

    // MARK: - Load JSON files
    func loadAll() async {
        do {
            try loadTeams()
            try loadScheduleAndGroup()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func loadJSON<T: Decodable>(_ filename: String) throws -> T {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            throw NSError(domain: "Missing \(filename)", code: 0)
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        return try decoder.decode(T.self, from: data)
    }

    private func loadTeams() throws {
        let resp: TeamsResponse = try loadJSON("teams.json")
        for t in resp.data.teams {
            teamsById[t.tid] = t
        }
    }

    private func loadScheduleAndGroup() throws {
        let resp: ScheduleResponse = try loadJSON("Schedule.json")
        let raw = resp.data.schedules

        let dateFormatter = ISO8601DateFormatter()
        var items: [GameViewModel] = raw.compactMap { game in
            let date = game.gametime.flatMap { dateFormatter.date(from: $0) }
            let homeTeam = teamsById[game.h.tid]
            let visitorTeam = teamsById[game.v.tid]
            return GameViewModel(
                id: game.uid,
                homeTid: game.h.tid,
                homeAbbr: game.h.ta ?? homeTeam?.ta ?? "",
                homeName: homeTeam?.tn ?? game.h.tn,
                homeLogo: homeTeam?.logo,
                visitorTid: game.v.tid,
                visitorAbbr: game.v.ta ?? visitorTeam?.ta ?? "",
                visitorName: visitorTeam?.tn ?? game.v.tn,
                visitorLogo: visitorTeam?.logo,
                date: date,
                st: game.st ?? 1,
                stt: game.stt,
                arena: game.arena_name ?? ""
            )
        }

        items.sort { ($0.date ?? Date.distantFuture) < ($1.date ?? Date.distantFuture) }

        // Group by month
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: items) { (item) -> DateComponents in
            guard let d = item.date else { return DateComponents() }
            return calendar.dateComponents([.year, .month], from: d)
        }

        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "LLLL yyyy"

        let keys = grouped.keys.sorted {
            guard let d1 = calendar.date(from: $0), let d2 = calendar.date(from: $1) else { return false }
            return d1 < d2
        }

        self.gamesByMonth = keys.map { comps in
            let date = calendar.date(from: comps) ?? Date()
            let name = monthFormatter.string(from: date)
            let list = grouped[comps] ?? []
            return (monthName: name, games: list.sorted(by: { ($0.date ?? Date()) < ($1.date ?? Date()) }))
        }
    }
}
