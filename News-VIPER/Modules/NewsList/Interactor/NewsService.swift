//
//  NewsService.swift
//  News-VIPER
//
//  Created by Miras Karazhigitov on 11.09.2021.
//

import Moya
import Foundation

struct News: Codable {
    let title: String
    let description: String
    let content: String
    let urlToImage: URL?
    
    init(title: String, description: String, content: String, urlToImage: URL? = nil) {
        self.title = title
        self.description = description
        self.content = content
        self.urlToImage = urlToImage
    }
}

enum NewsRequest: TargetType {
    case topHeadlines(Int), everything(Int)
    
    var baseURL: URL {
        URL(string: "https://newsapi.org")!
    }
    
    var path: String {
        switch self {
        case .topHeadlines:
            return "/v2/top-headlines"
        case .everything:
            return "/v2/everything"
        }
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Task {
        switch self {
        case .topHeadlines(let page):
            return .requestParameters(parameters: ["q": "Apple",
                                                   "apiKey": "e65ee0938a2a43ebb15923b48faed18d",
                                                   "pageSize": 15,
                                                   "page": page],
                                      encoding: URLEncoding.default)
        case .everything(let page):
            return .requestParameters(parameters: ["q": "Apple",
                                                   "apiKey": "e65ee0938a2a43ebb15923b48faed18d",
                                                   "pageSize": 15,
                                                   "page": page],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        nil
    }
}

struct NewsResponse: Codable {
    let articles: [News]
}

struct NewsService {
    func fetchNews(type: NewsRequest, completion: @escaping ([News], Error?) -> Void) {
        let provider = MoyaProvider<NewsRequest>()
        provider.request(type) { result in
            switch result {
            case .success(let response):
                var filteredResponse: Response!
                
                do {
                    filteredResponse = try response.filterSuccessfulStatusCodes()
                } catch {
                    completion([], NewsServiceError.statusError)
                }
                
                do {
                    let response = try filteredResponse.mapJSON()
                    print(response)
                    let decodedResponse = try filteredResponse.map(NewsResponse.self)
                    completion(decodedResponse.articles, nil)
                }
                catch {
                    completion([], NewsServiceError.mappingError)
                }
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    enum NewsServiceError: LocalizedError {
        case statusError
        case mappingError
        
        var errorDescription: String? {
            switch self {
            case .statusError:
                return "Status code is not ok"
            case .mappingError:
                return "Could not decode the model"
            }
        }
    }
}
