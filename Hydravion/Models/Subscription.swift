import Foundation
struct Subscription : Codable {
    let startDate : String?
    let endDate : String?
    let paymentID : Int?
    let interval : String?
    let paymentCancelled : Bool?
    let plan : Plan?
    let creator : String?
    
    enum CodingKeys: String, CodingKey {
        
        case startDate = "startDate"
        case endDate = "endDate"
        case paymentID = "paymentID"
        case interval = "interval"
        case paymentCancelled = "paymentCancelled"
        case plan = "plan"
        case creator = "creator"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
        endDate = try values.decodeIfPresent(String.self, forKey: .endDate)
        paymentID = try values.decodeIfPresent(Int.self, forKey: .paymentID)
        interval = try values.decodeIfPresent(String.self, forKey: .interval)
        paymentCancelled = try values.decodeIfPresent(Bool.self, forKey: .paymentCancelled)
        plan = try values.decodeIfPresent(Plan.self, forKey: .plan)
        creator = try values.decodeIfPresent(String.self, forKey: .creator)
    }
    
}
