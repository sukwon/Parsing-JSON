import Foundation

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

func getUserFromJSONSerialization(jsonData: Data) -> User? {
    do {
        var user: User?
        if let jsonObjc = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
            user = User(with: jsonObjc)
        } else {
            print("data is not a [String: Any] type")
        }
        return user
    } catch {
        print("json parsing error: \(error.localizedDescription)")
    }
    return nil
}

// Parse JSON

let url = Bundle.main.url(forResource: "User", withExtension: "json")!
let jsonData = try Data(contentsOf: url)
if let user1 = getUserFromDecoder(jsonData: jsonData) {
    print(user1)
}

print("----------------------------------------------------------------")

if let user2 = getUserFromJSONSerialization(jsonData: jsonData) {
    print(user2)
}


