//
//  TeamView.swift
//  BasketBallApp
//
//  Created by Shubham Deshmukh on 18/09/25.
//

import SwiftUI

struct TeamView: View {
    let abbr: String
    let name: String
    let logoURL: String?

    var body: some View {
        HStack(spacing: 8) {
            if let urlStr = logoURL, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 36, height: 36)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 36, height: 36)
                    case .failure:
                        fallback
                    @unknown default:
                        fallback
                    }
                }
            } else {
                fallback
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(abbr)
                    .font(.subheadline).bold()
                Text(name)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var fallback: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6).fill(Color.gray.opacity(0.3))
            Text(String(abbr.prefix(2)))
                .font(.subheadline).bold()
        }
        .frame(width: 36, height: 36)
    }
}
