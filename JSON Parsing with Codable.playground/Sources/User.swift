import Foundation

public enum Country: String, Codable {
    case korea
    case usa
    case china
    case unknown
}

public struct User {
    let name: String
    let weightInKg: Float
    let nickname: String
    let country: Country
    let birthDate: Date
    let profileURL: URL
}

extension User {
    public init(with jsonObjc: [String: Any]) {
        let name = jsonObjc["name"] as! String
        let weight = (jsonObjc["weight_in_kg"] as! NSNumber).floatValue
        let nickname = jsonObjc["nickname"] as! String
        let countryStr = jsonObjc["country"] as! String
        let profileUrlStr = jsonObjc["profile_url"] as! String
        
        var country: Country
        switch countryStr {
        case Country.korea.rawValue:
            country = .korea
        case Country.usa.rawValue:
            country = .usa
        case Country.china.rawValue:
            country = .china
        default:
            country = .unknown
        }
        
        let birthDateStr = jsonObjc["birth_date"] as! String
        let iso8601Date = ISO8601DateFormatter().date(from: birthDateStr)!
        
        let profileUrl = URL(string: profileUrlStr)!
        
        self.name = name
        self.weightInKg = weight
        self.nickname = nickname
        self.country = country
        self.birthDate = iso8601Date
        self.profileURL = profileUrl
    }
}

extension User: Codable {
    enum CodingKeys : String, CodingKey {
        case name
        case weightInKg = "weight_in_kg"
        case nickname
        case country
        case birthDate = "birth_date"
        case profileURL = "profile_url"
    }
}
