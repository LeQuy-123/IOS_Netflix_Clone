//
//  Movie.swift
//  Netflix clone
//
//  Created by mac on 14/7/24.
//

import Foundation

struct TitleResponse: Codable {
    let page: Int
    let results: [Title]
    let total_pages: Int
    let total_results: Int
}

struct Title: Codable {
    let id: Int
    let name: String?
    let title: String?
    let overview: String
    let poster_path: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
    let backdrop_path: String?
    let popularity: Double
    let original_language: String
    let original_title: String?
    let genre_ids: [Int]
    let adult: Bool?
    let video: Bool?
}

// To parse the JSON, add this method:

func parseTitleResponse(from data: Data) -> TitleResponse? {
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(TitleResponse.self, from: data)
        return response
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}
