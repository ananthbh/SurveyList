//
//  XAuthTokenPlugin.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 23/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Moya

public protocol XAuthAuthorizable {
    
    var shouldXAuthAuthorize: Bool { get }
}

struct XAuthTokenPlugin: PluginType {
    
    let tokenClosure: () -> String?
    
    init(tokenClosure: @escaping @autoclosure () -> String?) {
        self.tokenClosure = tokenClosure
    }
    
    fileprivate var authVal: String {
        guard let token = tokenClosure() else { return "" }
        return token
    }
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let authorizable = target as? XAuthAuthorizable, authorizable.shouldXAuthAuthorize == false {
            return request
        }
        
        var request = request
        request.addValue(authVal, forHTTPHeaderField: "Authorization")
        
        return request
    }
}
