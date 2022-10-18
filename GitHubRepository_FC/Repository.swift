//
//  Repository.swift
//  GitHubRepository_FC
//
//  Created by YoonDaesung on 2022/10/18.
//

import Foundation

struct Repository: Decodable {
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        // Json과 동일하여 그대로 둠
        case id, name, description, language
        
        // Json과 받는 타입이 달라서 변경
        case stargazersCount = "stargazers_count"
    }
}
