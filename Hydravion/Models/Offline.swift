import Foundation
struct Offline : Codable {
    let title : String?
    let description : String?
    let thumbnail : Thumbnail?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case description = "description"
        case thumbnail = "thumbnail"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
    }

}
