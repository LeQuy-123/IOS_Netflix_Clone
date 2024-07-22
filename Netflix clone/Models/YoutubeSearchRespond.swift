//
//  YoutubeSearchRespond.swift
//  Netflix clone
//
//  Created by mac on 15/7/24.
//

import Foundation

// MARK: - YouTubeSearchListResponse
struct YouTubeSearchListResponse: Codable {
    let kind: String
    let etag: String
    let nextPageToken: String
    let regionCode: String
    let pageInfo: PageInfo
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let kind: String
    let etag: String
    let id: ID
}

// MARK: - ID
struct ID: Codable {
    let kind: String
    let channelId: String?
    let videoId: String?
}

// MARK: - PageInfo
struct PageInfo: Codable {
    let totalResults: Int
    let resultsPerPage: Int
}

func parseYouTubeSearchListResponse(from jsonData: Data) -> YouTubeSearchListResponse? {
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(YouTubeSearchListResponse.self, from: jsonData)
        return response
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
