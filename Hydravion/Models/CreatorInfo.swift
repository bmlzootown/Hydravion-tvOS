import Foundation
struct CreatorInfo : Codable {
    let id : String?
    let owner : String?
    let title : String?
    let urlname : String?
    let description : String?
    let about : String?
    let category : String?
    let cover : Cover?
    let icon : Icon?
    let liveStream : LiveStream?
    let subscriptionPlans : String?
    let discoverable : Bool?
    let subscriberCountDisplay : String?
    let incomeDisplay : Bool?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case owner = "owner"
        case title = "title"
        case urlname = "urlname"
        case description = "description"
        case about = "about"
        case category = "category"
        case cover = "cover"
        case icon = "icon"
        case liveStream = "liveStream"
        case subscriptionPlans = "subscriptionPlans"
        case discoverable = "discoverable"
        case subscriberCountDisplay = "subscriberCountDisplay"
        case incomeDisplay = "incomeDisplay"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        owner = try values.decodeIfPresent(String.self, forKey: .owner)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        urlname = try values.decodeIfPresent(String.self, forKey: .urlname)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        about = try values.decodeIfPresent(String.self, forKey: .about)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        cover = try values.decodeIfPresent(Cover.self, forKey: .cover)
        icon = try values.decodeIfPresent(Icon.self, forKey: .icon)
        liveStream = try values.decodeIfPresent(LiveStream.self, forKey: .liveStream)
        subscriptionPlans = try values.decodeIfPresent(String.self, forKey: .subscriptionPlans)
        discoverable = try values.decodeIfPresent(Bool.self, forKey: .discoverable)
        subscriberCountDisplay = try values.decodeIfPresent(String.self, forKey: .subscriberCountDisplay)
        incomeDisplay = try values.decodeIfPresent(Bool.self, forKey: .incomeDisplay)
    }

}
