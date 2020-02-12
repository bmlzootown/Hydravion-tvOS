import Foundation
struct LiveStream : Codable {
    let id : String?
    let title : String?
    let description : String?
    let thumbnail : Thumbnail?
    let owner : String?
    let streamPath : String?
    let offline : Offline?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case description = "description"
        case thumbnail = "thumbnail"
        case owner = "owner"
        case streamPath = "streamPath"
        case offline = "offline"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        owner = try values.decodeIfPresent(String.self, forKey: .owner)
        streamPath = try values.decodeIfPresent(String.self, forKey: .streamPath)
        offline = try values.decodeIfPresent(Offline.self, forKey: .offline)
    }

}
