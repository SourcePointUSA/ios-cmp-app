//
//  SPLocalStorage.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 07.05.20.
//

import Foundation

protocol Storage {
    func integer(forKey defaultName: String) -> Int
    func string(forKey defaultName: String) -> String?
    func object<T: Decodable>(ofType type: T.Type, forKey defaultName: String) -> T?
    func set(_ value: Any?, forKey defaultName: String)
    func setObject<T: Encodable>(_ value: T, forKey defaultName: String)
    func setValuesForKeys(_ keyedValues: [String: Any])
    func removeObject(forKey defaultName: String)
    func removeObjects(forKeys keys: [String])
    func dictionaryRepresentation() -> [String: Any]
}

extension UserDefaults: Storage {
    func setObject<T: Encodable>(_ value: T, forKey defaultName: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encodeResult(value).get() {
            self.set(encoded, forKey: defaultName)
        }
    }

    func object<T>(ofType type: T.Type, forKey defaultName: String) -> T? where T: Decodable {
        let decoder = JSONDecoder()
        if let data = self.data(forKey: defaultName),
           let object = try? decoder.decode(type, from: data).get() {
            return object
        }
        return nil
    }

    func removeObjects(forKeys keys: [String]) {
        keys.forEach { removeObject(forKey: $0) }
    }
}

protocol SPLocalStorage {
    var storage: Storage { get set }
    var tcfData: [String: Any]? { get set }
    var usPrivacyString: String? { get set }
    var userData: SPUserData { get set }
    var localState: SPJson { get set }
    var propertyId: Int? { get set }

    func clear()

    init(storage: Storage)
}
