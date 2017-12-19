import Foundation

struct Photo: Decodable {
    let photoLink: String
    let thumbLink: String
    
    enum CodingKeys: String, CodingKey {
        case photoLink = "photo_link"
        case thumbLink = "thumb_link"
    }
}
