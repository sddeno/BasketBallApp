//
//  Team.swift
//  BasketBallApp
//
//  Created by Shubham Deshmukh on 18/09/25.
//

import Foundation

// MARK: - Teams JSON
struct TeamsResponse: Codable {
    let data: TeamsData
}

struct TeamsData: Codable {
    let teams: [Team]
}

struct Team: Codable, Identifiable {
    var id: String { tid }
    let uid: String?
    let year: Int?
    let tid: String        // team id like "1610612748"
    let tn: String?        // team name e.g. "Heat"
    let ta: String?        // abbreviation e.g. "MIA"
    let tc: String?        // city e.g. "Miami"
    let logo: String?      // URL string for logo
    let color: String?
}
