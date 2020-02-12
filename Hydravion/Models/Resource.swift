import Foundation
struct Resource : Codable {
    let uri : String?
    let resourceData : ResourceData?

    enum CodingKeys: String, CodingKey {

        case uri = "uri"
        case resourceData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uri = try values.decodeIfPresent(String.self, forKey: .uri)
        resourceData = try values.decodeIfPresent(ResourceData.self, forKey: .resourceData)
    }

}

