import Foundation
struct Icon : Codable {
    let width : Int?
    let height : Int?
    let path : String?
    let childImages : [ChildImages]?

    enum CodingKeys: String, CodingKey {

        case width = "width"
        case height = "height"
        case path = "path"
        case childImages = "childImages"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decodeIfPresent(Int.self, forKey: .width)
        height = try values.decodeIfPresent(Int.self, forKey: .height)
        path = try values.decodeIfPresent(String.self, forKey: .path)
        childImages = try values.decodeIfPresent([ChildImages].self, forKey: .childImages)
    }

}
