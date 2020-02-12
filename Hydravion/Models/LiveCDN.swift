import Foundation
struct LiveCDN : Codable {
    let cdn : String?
    let strategy : String?
    let resource : Resource?

    enum CodingKeys: String, CodingKey {

        case cdn = "cdn"
        case strategy = "strategy"
        case resource = "resource"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cdn = try values.decodeIfPresent(String.self, forKey: .cdn)
        strategy = try values.decodeIfPresent(String.self, forKey: .strategy)
        resource = try values.decodeIfPresent(Resource.self, forKey: .resource)
    }

}
