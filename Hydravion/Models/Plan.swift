import Foundation
struct Plan : Codable {
    let id : String?
    let title : String?
    let description : String?
    let price : String?
    let priceYearly : String?
    let currency : String?
    let logo : String?
    let interval : String?

    enum CodingKeys: String, CodingKey {

        case id = "id"
        case title = "title"
        case description = "description"
        case price = "price"
        case priceYearly = "priceYearly"
        case currency = "currency"
        case logo = "logo"
        case interval = "interval"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        priceYearly = try values.decodeIfPresent(String.self, forKey: .priceYearly)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        logo = try values.decodeIfPresent(String.self, forKey: .logo)
        interval = try values.decodeIfPresent(String.self, forKey: .interval)
    }

}
