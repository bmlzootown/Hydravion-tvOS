import Foundation
struct Video : Codable {
    let title : String?
    let guid : String?
    let description : String?
    let `private` : Bool?
    let releaseDate : String?
    let duration : Int?
    let creator : String?
    let subscriptionPermissions : [String]?
    let thumbnail : Thumbnail?
    let hasAccess : Bool?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case guid = "guid"
        case description = "description"
        case `private` = "private"
        case releaseDate = "releaseDate"
        case duration = "duration"
        case creator = "creator"
        case subscriptionPermissions = "subscriptionPermissions"
        case thumbnail = "thumbnail"
        case hasAccess = "hasAccess"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        guid = try values.decodeIfPresent(String.self, forKey: .guid)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        `private` = try values.decodeIfPresent(Bool.self, forKey: .private)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        creator = try values.decodeIfPresent(String.self, forKey: .creator)
        subscriptionPermissions = try values.decodeIfPresent([String].self, forKey: .subscriptionPermissions)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        hasAccess = try values.decodeIfPresent(Bool.self, forKey: .hasAccess)
    }

}
