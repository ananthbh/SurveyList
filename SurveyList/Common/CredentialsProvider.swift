//
//  CredentialsProvider.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 23/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Foundation

public final class CredentialsProvider: Service {
    
    struct StoredCredentialsKeys {
        static let kTokenKey      = "access_token"
        static let kExpirationKey = "expires_in"
        static let kCreatedAt     = "created_at"
        static let kTokenType     = "token_type"
    }
    
    public var token: String?
    public var expires: Double?
    public var createdAt: Double?
    public var tokenType: String?
    
    public var username = "carlos@nimbl3.com"
    public var password = "antikera"
    
    fileprivate let keychainService = KeyChain()
    fileprivate let defaults = UserDefaults.standard
    
    public var tokenExpired: Bool {
        if token == nil { return true }
        guard let expirationTimeInterval = expires else { return true }
        let date = Date().timeIntervalSince1970
        return date+3600 >= expirationTimeInterval
    }
    
    public init() {
        
        if let tokenValue = KeyChain.load(key: StoredCredentialsKeys.kTokenKey) {
            token = tokenValue
        }
        
        if defaults.value(forKey: StoredCredentialsKeys.kExpirationKey) != nil {
            expires = defaults.double(forKey: StoredCredentialsKeys.kExpirationKey)
        }
        
        if defaults.value(forKey: StoredCredentialsKeys.kCreatedAt) != nil {
            createdAt = defaults.double(forKey: StoredCredentialsKeys.kCreatedAt)
        }
        
        if defaults.value(forKey: StoredCredentialsKeys.kTokenType) != nil {
            tokenType = defaults.string(forKey: StoredCredentialsKeys.kTokenType)
        }
    }
    
    func saveCredentials() {
        guard let token = token else { return }
        KeyChain.save(key: StoredCredentialsKeys.kTokenKey, string: token)
        defaults.set(expires!, forKey: StoredCredentialsKeys.kExpirationKey)
        defaults.set(createdAt!, forKey: StoredCredentialsKeys.kCreatedAt)
        defaults.set(tokenType!, forKey: StoredCredentialsKeys.kTokenType)
    }
    
    func clearCredentials() {
        KeyChain.delete(key: StoredCredentialsKeys.kTokenKey)
        if defaults.value(forKey: StoredCredentialsKeys.kExpirationKey) != nil {
            defaults.removeObject(forKey: StoredCredentialsKeys.kExpirationKey)
            defaults.synchronize()
        }
        
        if defaults.value(forKey: StoredCredentialsKeys.kCreatedAt) != nil {
            defaults.removeObject(forKey: StoredCredentialsKeys.kCreatedAt)
            defaults.synchronize()
        }
        
        if defaults.value(forKey: StoredCredentialsKeys.kTokenType) != nil {
            defaults.removeObject(forKey: StoredCredentialsKeys.kTokenType)
            defaults.synchronize()
        }
     }

}
