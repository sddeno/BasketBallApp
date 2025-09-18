//
//  Schedule.swift
//  BasketBallApp
//
//  Created by Shubham Deshmukh on 18/09/25.
//

import Foundation

// MARK: - Schedule JSON
struct ScheduleResponse: Codable {
    let data: ScheduleData
}

struct ScheduleData: Codable {
    let schedules: [GameRaw]
}

struct GameRaw: Codable, Identifiable {
    let uid: String
    let year: Int?
    let gid: String?
    let gametime: String?      // ISO string like 2025-04-13T17:00:00.000Z
    let arena_name: String?
    let arena_city: String?
    let arena_state: String?
    let st: Int?               // status key: 1 future, 2 live, 3 past
    let stt: String?           // display time text
    let h: TeamRef             // home team
    let v: TeamRef             // visitor team

    var id: String { uid }
}

struct TeamRef: Codable {
    let tid: String
    let ta: String?
    let tn: String?
    let tc: String?
    let s: String? // score (string)
}

// MARK: - View Model object for UI
struct GameViewModel: Identifiable {
    let id: String
    let homeTid: String
    let homeAbbr: String
    let homeName: String?
    let homeLogo: String?
    let visitorTid: String
    let visitorAbbr: String
    let visitorName: String?
    let visitorLogo: String?
    let date: Date?
    let st: Int
    let stt: String?
    let arena: String?
}
