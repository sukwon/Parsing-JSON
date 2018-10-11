//: [Previous](@previous)

import Foundation

// Codable decode

func getUserFromDecoder(jsonData: Data) -> User? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    var user: User?
    do {
        let response = try decoder.decode(Response.self, from: jsonData)
        user = response.users.first
    } catch {
        print("json parsing error: \(error.localizedDescription)")
    }
    return user
}

let url = Bundle.main.url(forResource: "Response", withExtension: "json")!
let jsonData = try Data(contentsOf: url)
if let user1 = getUserFromDecoder(jsonData: jsonData) {
    print(user1)
}

//: [Next](@next)
