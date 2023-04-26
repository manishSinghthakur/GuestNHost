//  RestaurantMenuResponseModel.swift
//  Nisumapp (iOS)
//
//  Created by nisum on 07/01/22.
//  Copyright © 2022 Nisum. All rights reserved.
//
import Foundation

// MARK: - MenuItems
struct MenuItems: Codable, Identifiable, Hashable {
    let restaurant: Restaurant
    let menuDataList: [MenuDataList]
    var id: String {restaurant.id}

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: MenuItems, rhs: MenuItems) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case restaurant
        case menuDataList
    }
}

// MARK: - MenuDataList
struct MenuDataList: Codable, Identifiable, Hashable {
    let restaurantMenu: RestaurantMenu
    let categoryList: [CategoryList]?
    var id: String {restaurantMenu.id }

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: MenuDataList, rhs: MenuDataList) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case restaurantMenu
        case categoryList
    }
}


// MARK: - CategoryList
struct CategoryList: Codable, Identifiable, Hashable {
    let category: Category?
    let itemData: [ItemDatum]?
    let recipeBOS: [RecipeBO]?
    var id: String {category?.categoryID ?? ""}
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: CategoryList, rhs: CategoryList) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case category = "category"
        case itemData = "itemData"
        case recipeBOS = "recipeBOS"
    }
}

// MARK: - ItemDatum
struct ItemDatum: Codable, Identifiable, Hashable {
    let item: ItemD?
    let recipeBOS: [RecipeBO]?
    var id: String {item?.itemID ?? ""}

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: ItemDatum, rhs: ItemDatum) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Item
struct ItemD: Codable, Identifiable, Hashable {
    let itemID, itemName, categoryID: String
    let status: String?
    var id: String {itemID}

    enum CodingKeys: String, CodingKey {
        case itemID = "itemId"
        case itemName
        case categoryID = "categoryId"
        case status
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.itemID = try values.decodeIfPresent(String.self, forKey: .itemID) ?? ""
        self.itemName = try values.decodeIfPresent(String.self, forKey: .itemName) ?? ""
        self.categoryID = try values.decodeIfPresent(String.self, forKey: .categoryID) ?? ""
        self.status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: ItemD, rhs: ItemD) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Category
struct Category:Codable, Identifiable , Hashable{
    let categoryID, categoryName, menuID, status: String?
    let categoryType: String?
    let imageURL: String?
    var id: String {categoryID ?? ""}
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "categoryId"
        case categoryName
        case menuID = "menuId"
        case imageURL = "imageUrl"
        case status, categoryType
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.categoryID = try values.decodeIfPresent(String.self, forKey: .categoryID) ?? ""
        self.categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName) ?? ""
        self.menuID = try values.decodeIfPresent(String.self, forKey: .menuID) ?? ""
        self.status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        self.categoryType = try values.decodeIfPresent(String.self, forKey: .categoryType) ?? ""
        self.imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - RecipeBO
struct RecipeBO: Codable, Identifiable, Hashable {
    let recipeID, recipeName, recipeBODescription, price: String
    let itemID: String?
    let imageURL: String?
    let categoryId: String?
    let status: String?
    var id: String {recipeID}

    enum CodingKeys: String, CodingKey {
        case recipeID = "recipeId"
        case recipeName
        case recipeBODescription = "description"
        case price
        case categoryId
        case itemID = "itemId"
        case imageURL = "imageUrl"
        case status
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.recipeID = try values.decodeIfPresent(String.self, forKey: .recipeID) ?? ""
        self.recipeName = try values.decodeIfPresent(String.self, forKey: .recipeName) ?? ""
        self.recipeBODescription = try values.decodeIfPresent(String.self, forKey: .recipeBODescription) ?? ""
        self.price = try values.decodeIfPresent(String.self, forKey: .price) ?? ""
        self.categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId) ?? ""
        self.itemID = try values.decodeIfPresent(String.self, forKey: .itemID) ?? ""
        self.imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        self.status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: RecipeBO, rhs: RecipeBO) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - RestaurantMenu
struct RestaurantMenu: Codable, Identifiable, Hashable {
    let menuID, menuName, menuType, restaurantMenuDescription: String
    let restaurantID, restaurantName: String?
    let images: [JSONAny]?
    let nextImageID: Int?
    let status: String?
    let activeFor: [ActiveFor]?
    var id: String {menuID}

    enum CodingKeys: String, CodingKey {
        case menuID = "menuId"
        case menuName, menuType
        case restaurantMenuDescription = "description"
        case restaurantID = "restaurantId"
        case restaurantName, images
        case nextImageID = "nextImageId"
        case status, activeFor
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: RestaurantMenu, rhs: RestaurantMenu) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - ActiveFor
struct ActiveFor: Codable {
    let name, from, to: String
}

struct Restaurant: Codable {
    let restaurantID, restaurantName, restaurantDescription, address: String
        let managerName, phoneNo, cuisineType, email: String
        let zipCode: String?
        let imageURL: String?
        let timings: [Timing]?
        let reasonList: [ReasonList]?
        let contactInfo: ContactInfo?
        let services: [String]?
        let qrCode: String?
        let geoLocation: GeoLocation?
        let latitude, longitude: Double?
        let status: String?
        var id: String {restaurantID}

        enum CodingKeys: String, CodingKey {
            case restaurantID = "restaurantId"
            case restaurantName
            case restaurantDescription = "description"
            case address, managerName, phoneNo, cuisineType, email, zipCode
            case imageURL = "imageUrl"
            case timings, reasonList, contactInfo, services, qrCode, geoLocation, latitude, longitude, status
        }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: Restaurant, rhs: Restaurant) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Contact
struct Contact: Codable {
    let restaurantEmail: String?
    let restaurantWebsite: JSONNulls?
    let restaurantPhone, facebookHandle, twitterHandle: String?
}

// MARK: - GeoLocation
struct GeoLocation: Codable {
    let longitude, latitude: Double?
}

// MARK: - ReasonList
struct ReasonList: Codable {
    let id, restaurantID: JSONNulls?
    let role, comment: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case restaurantID = "restaurantId"
        case role, comment
    }
}

// MARK: - Timings
struct Timings: Codable {
    let name, fromTime, toTime: String?
}

// MARK: - Encode/decode helpers

class JSONNulls: Codable, Hashable {
    
    public static func == (lhs: JSONNulls, rhs: JSONNulls) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNulls.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNulls"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKeys: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAnys: Codable {
    
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAnys")
        return DecodingError.typeMismatch(JSONAnys.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAnys")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNulls()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNulls()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKeys.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKeys>, forKey key: JSONCodingKeys) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNulls()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKeys>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNulls {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKeys.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKeys>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKeys(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNulls {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNulls {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAnys.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKeys.self) {
            self.value = try JSONAnys.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAnys.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAnys.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKeys.self)
            try JSONAnys.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAnys.encode(to: &container, value: self.value)
        }
    }
}
