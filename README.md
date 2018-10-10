# Parsing-JSON
Compare between using Codable vs JSONSerialization to parse JSON

if we use decodable, the code will look like this
```
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
```
