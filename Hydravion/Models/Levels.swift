import Foundation
struct Levels : Codable {
    let name : String?
    let width : Int?
    let height : Int?
    let order : Int?
    let label : String?

    enum CodingKeys: String, CodingKey {

        case name = "name"
        case width = "width"
        case height = "height"
        case order = "order"
        case label = "label"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        order = try values.decodeIfPresent(Int.self, forKey: .order)
        label = try values.decodeIfPresent(String.self, forKey: .label)
    }

}
