//
//  DictionaryManager.swift
//  AutoInputSource
//
//  Created by 梁波 on 2024/3/18.
//

import Foundation

class DictionaryManager {
    static let shared = DictionaryManager()
    private let defaults = UserDefaults.standard

    private init() {}

    // 存储字典到 UserDefaults
    func saveDictionary<K: Hashable, V>(_ dictionary: [K: V], forKey key: K) {
        defaults.set(dictionary, forKey: "\(key)")
    }

    // 从 UserDefaults 中检索字典
    func loadDictionary<K: Hashable, V>(forKey key: K) -> [K: V]? {
        return defaults.dictionary(forKey: "\(key)") as? [K: V]
    }
    
    // 向字典中添加新的键值对
    func addKeyValue<K: Hashable, V>(key: K, value: V, forKey dictionaryKey: K) {
        var dictionary = loadDictionary(forKey: dictionaryKey) ?? [:]
        dictionary[key] = value
        saveDictionary(dictionary, forKey: dictionaryKey)
    }
    
    // 从字典中移除指定的键值对
    func removeKey<K: Hashable>(key: K, forKey dictionaryKey: K) {
        var dictionary = loadDictionary(forKey: dictionaryKey) ?? [:]
        dictionary.removeValue(forKey: key)
        saveDictionary(dictionary, forKey: dictionaryKey)
    }
    
    // 更新字典中指定键的值
    func updateValueForKey<K: Hashable, V>(key: K, value: V, forKey dictionaryKey: K) {
        var dictionary = loadDictionary(forKey: dictionaryKey) ?? [:]
        dictionary[key] = value
        saveDictionary(dictionary, forKey: dictionaryKey)
    }
}


// 调用示例
//DictionaryManager.shared.addKeyValuePair(key: "Name", value: "John", forKey: "UserInfo")
//DictionaryManager.shared.addKeyValuePair(key: "Age", value: 30, forKey: "UserInfo")
//
//let userInfoDictionary: [String: String]? = DictionaryManager.shared.loadDictionary(forKey: "UserInfo")
//if let userInfo = userInfoDictionary {
//    print("User Info: \(userInfo)")
//} else {
//    print("No user info found.")
//}
//
//DictionaryManager.shared.removeKeyValuePair(key: "Age", forKey: "UserInfo")
//
//let updatedUserInfoDictionary = DictionaryManager.shared.loadDictionary(forKey: "UserInfo")
//if let updatedUserInfo = updatedUserInfoDictionary {
//    print("Updated User Info: \(updatedUserInfo)")
//} else {
//    print("No user info found.")
//}
