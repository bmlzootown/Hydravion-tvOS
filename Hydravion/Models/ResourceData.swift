import Foundation
struct ResourceData : Codable {
    let token : String?

    enum CodingKeys: String, CodingKey {

        case token = "token"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
    
    subscript(index: String) -> String {
        return token!
    }

}
