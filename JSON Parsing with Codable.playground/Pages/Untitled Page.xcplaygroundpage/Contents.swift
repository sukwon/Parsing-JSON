import Foundation

struct User {
    enum Country: String, Codable {
        case korea
        case usa
        case china
        case unknown
    }
    
    let name: String
    let weightInKg: Float
    let nickname: String
    let country: Country
    let birthDate: Date
    let profileURL: URL
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

// Codable decode

func getUserFromDecoder(jsonData: Data) -> User? {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    var user: User?
    do {
        user = try decoder.decode(User.self, from: jsonData)
    } catch {
        print("json parsing error: \(error.localizedDescription)")
    }
    return user
}

// Codable encode

func getString(from user: User) -> String? {
    let encoder = JSONEncoder()
//    encoder.outputFormatting = .prettyPrinted // default is compact
    var resultStr: String?
    do  {
        let data = try encoder.encode(user)
        resultStr = String(data: data, encoding: .utf8)
    } catch {
        print(error.localizedDescription)
    }
    return resultStr
}

// Old way

extension String {
    func toDate(dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        let date: Date? = dateFormatter.date(from: self)
        return date
    }
}

typealias JSONDictionary = [String: Any]

func getUserFromJSONSerialization(jsonData: Data) -> User? {
    do {
        var user: User?
        if let jsonObjc = try JSONSerialization.jsonObject(with: jsonData) as? JSONDictionary {
            let name = jsonObjc["name"] as! String
            let weight = (jsonObjc["weight_in_kg"] as! NSNumber).floatValue
            let nickname = jsonObjc["nickname"] as! String
            let countryStr = jsonObjc["country"] as! String
            let profileUrlStr = jsonObjc["profile_url"] as! String

            var country: User.Country
            switch countryStr {
            case User.Country.korea.rawValue:
                country = .korea
            case User.Country.usa.rawValue:
                country = .usa
            case User.Country.china.rawValue:
                country = .china
            default:
                country = .unknown
            }
            
            let birthDateStr = jsonObjc["birth_date"] as! String
            let iso8601Date = ISO8601DateFormatter().date(from: birthDateStr)!
            
            let profileUrl = URL(string: profileUrlStr)!
            
            user = User(name: name, weightInKg: weight, nickname: nickname, country: country, birthDate: iso8601Date, profileURL: profileUrl)
        } else {
            print("data is not a [String: Any] type")
        }
        return user
    } catch {
        print("json parsing error: \(error.localizedDescription)")
    }
    return nil
}

let url = Bundle.main.url(forResource: "User", withExtension: "json")!
let jsonData = try Data(contentsOf: url)
if let user1 = getUserFromDecoder(jsonData: jsonData) {
    print(user1)
    print(getString(from: user1)!)
}

print("----------------------------------------------------------------")

if let user2 = getUserFromJSONSerialization(jsonData: jsonData) {
    print(user2)
}


