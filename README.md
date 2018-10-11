# Parsing-JSON
Compare between using Codable vs JSONSerialization to parse JSON

if we use decodable, the code will look like this

```
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
```

if we use JSONSerialization, the code will look like this
```
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
```
