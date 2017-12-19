import Foundation

// MARK: - Group

struct Group {
    let id: String
    let keyPhotoURL: URL
    let name: String
    let localizedLocation: String
    let memberCount: Int
}

// MARK: - Decodable

extension Group: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case keyPhoto = "key_photo"
        case name
        case localizedLocation = "localized_location"
        case memberCount = "members"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = String(try values.decode(Int.self, forKey: .id))
        
        let keyPhoto = try values.decode(Photo.self, forKey: CodingKeys.keyPhoto)
        self.keyPhotoURL = URL(string: keyPhoto.photoLink)!
        
        self.name = try values.decode(String.self, forKey: CodingKeys.name)
        self.localizedLocation = try values.decode(String.self, forKey: CodingKeys.localizedLocation)
        self.memberCount = try values.decode(Int.self, forKey: CodingKeys.memberCount)
    }
}
