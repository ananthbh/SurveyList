//
//  KeyChain.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 23/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Foundation
import Security

final class KeyChain {
    
    fileprivate static let KeyChainService = "SurveySecrets"
    
    @discardableResult class func save(key: String, string: String) -> Bool {
        
        let data = string.data(using: .utf8, allowLossyConversion: false)!
        
        let query = [
            kSecClass as String       : kSecClassGenericPassword as String,
            kSecAttrAccount as String : key,
            kSecValueData as String   : data,
            kSecAttrService as String : KeyChainService ] as [String : Any]
        
        SecItemDelete(query as CFDictionary)
        
        let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
        
        return status == noErr
    }
    
    class func load(key: String) -> String? {
        
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecReturnData as String  : kCFBooleanTrue,
            kSecMatchLimit as String  : kSecMatchLimitOne,
            kSecAttrService as String : KeyChainService ] as [String : Any]
        
        var dataTypeRef: AnyObject?
        let status: OSStatus = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == noErr {
            let data = dataTypeRef as? Data
            if let data = data {
                return String(data: data, encoding: .utf8)
            } else {
                debugPrint("Error: Couldn't load keychain item for \(key)")
                return nil
            }
        }
        else {
            debugPrint("Error: Couldn't load keychain item for \(key)")
            return nil
        }
        
        
    }
    
    @discardableResult class func delete(key: String) -> Bool {
        let query = [
            kSecClass as String       : kSecClassGenericPassword,
            kSecAttrAccount as String : key,
            kSecAttrService as String : KeyChainService ] as [String : Any]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
    
    @discardableResult class func clear() -> Bool {
        let query = [ kSecClass as String : kSecClassGenericPassword,
                      kSecAttrService as String : KeyChainService ] as [String : Any]
        
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        
        return status == noErr
    }
    
}
