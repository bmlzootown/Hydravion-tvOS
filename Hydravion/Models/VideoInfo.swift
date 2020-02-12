import Foundation
struct VideoInfo : Codable {
    let title : String?
    let guid : String?
    let tags : [String]?
    let description : String?
    let `private` : Bool?
    let releaseDate : String?
    let duration : Int?
    let creator : String?
    let subscriptionPermissions : [String]?
    let timelineSprite : TimelineSprite?
    let thumbnail : Thumbnail?
    let levels : [Levels]?
    let state : String?
    let canWatchVideo : Bool?

    enum CodingKeys: String, CodingKey {

        case title = "title"
        case guid = "guid"
        case tags = "tags"
        case description = "description"
        case `private` = "private"
        case releaseDate = "releaseDate"
        case duration = "duration"
        case creator = "creator"
        case subscriptionPermissions = "subscriptionPermissions"
        case timelineSprite = "timelineSprite"
        case thumbnail = "thumbnail"
        case levels = "levels"
        case state = "state"
        case canWatchVideo = "canWatchVideo"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        guid = try values.decodeIfPresent(String.self, forKey: .guid)
        tags = try values.decodeIfPresent([String].self, forKey: .tags)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        `private` = try values.decodeIfPresent(Bool.self, forKey: .private)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        duration = try values.decodeIfPresent(Int.self, forKey: .duration)
        creator = try values.decodeIfPresent(String.self, forKey: .creator)
        subscriptionPermissions = try values.decodeIfPresent([String].self, forKey: .subscriptionPermissions)
        timelineSprite = try values.decodeIfPresent(TimelineSprite.self, forKey: .timelineSprite)
        thumbnail = try values.decodeIfPresent(Thumbnail.self, forKey: .thumbnail)
        levels = try values.decodeIfPresent([Levels].self, forKey: .levels)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        canWatchVideo = try values.decodeIfPresent(Bool.self, forKey: .canWatchVideo)
    }

}
