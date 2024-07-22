//
//  APICaller.swift
//  Netflix clone
//
//  Created by mac on 14/7/24.
//

import Foundation

struct Constants {
    static let API_KEY = "e0ebac89c2593fa46ed9311d3623d258"
    static let BASE_URL = "https://api.themoviedb.org"
    static let VERSION = "3"
    static let YOUTUBE_API_KEY = "AIzaSyBIKmHyX8nLxORBYrXBRRSbcbFjpH3swmo"
    static let YOUTUBE_BASE_URL = "https://youtube.googleapis.com"
    static let YOUTUBE_API_VERSION = "v3"
}

enum APIError: Error {
    case failedToGetData
    case failedToParseResponse
    case invalidURL
    case custom(errorMessage: String)
}

class APICaller {
    static let shared = APICaller()
    
    func getTrendingMovie(completion: @escaping (Result<[Title], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/\(Constants.VERSION)/trending/movie/day?api_key=\(Constants.API_KEY)")else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            if let trendingMoviesResponse = parseTitleResponse(from: data) {
                completion(.success(trendingMoviesResponse.results))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
    func getTopRated(completion: @escaping (Result<[Title], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/\(Constants.VERSION)/movie/top_rated?api_key=\(Constants.API_KEY)")else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            if let trendingMoviesResponse = parseTitleResponse(from: data) {
                completion(.success(trendingMoviesResponse.results))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
    func getTrendingTv(completion: @escaping (Result<[Title], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/\(Constants.VERSION)/trending/tv/day?api_key=\(Constants.API_KEY)")else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            if let trendingTVsResponse = parseTitleResponse(from: data) {
                completion(.success(trendingTVsResponse.results))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
    
    func getPoppularMovie(completion: @escaping (Result<[Title], APIError>) -> Void) {
        guard let url = URL(string: "\(Constants.BASE_URL)/\(Constants.VERSION)/movie/popular?api_key=\(Constants.API_KEY)")else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
            
            if let trendingMoviesResponse = parseTitleResponse(from: data) {
                completion(.success(trendingMoviesResponse.results))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
    
    func getUpcommingMovie(page: Int = 1, completion: @escaping (Result<[Title], APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)/\(Constants.VERSION)/movie/upcoming?api_key=\(Constants.API_KEY)&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
            
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
         
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
             
            if let trendingMoviesResponse = parseTitleResponse(from: data) {
                completion(.success(trendingMoviesResponse.results))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
    
    func discoverMovie(page: Int = 1, completion: @escaping (Result<[Title], APIError>) -> Void) {
        let urlString = "\(Constants.BASE_URL)/\(Constants.VERSION)/discover/movie?api_key=\(Constants.API_KEY)&page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
            
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
         
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
             
            if let trendingMoviesResponse = parseTitleResponse(from: data) {
                completion(.success(trendingMoviesResponse.results))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
    
    func search(with query: String, page: Int = 1, completion: @escaping (Result<[Title], APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let urlString = "\(Constants.BASE_URL)/\(Constants.VERSION)/search/movie?api_key=\(Constants.API_KEY)&query=\(query)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
            
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
         
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
             
            if let trendingMoviesResponse = parseTitleResponse(from: data) {
                completion(.success(trendingMoviesResponse.results))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
    
    func getYoutubeData(with query: String, page: Int = 1, completion: @escaping (Result<YouTubeSearchListResponse, APIError>) -> Void) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        let urlString = "\(Constants.YOUTUBE_BASE_URL)/youtube/\(Constants.YOUTUBE_API_VERSION)/search?key=\(Constants.YOUTUBE_API_KEY)&q=\(query)"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
         
            guard let data = data else {
                completion(.failure(.failedToGetData))
                return
            }
             
            if let res = parseYouTubeSearchListResponse(from: data) {
                completion(.success(res))
            } else {
                completion(.failure(.failedToParseResponse))
            }
        }
        task.resume()
    }
}

