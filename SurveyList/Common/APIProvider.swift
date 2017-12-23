//
//  APIProvider.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 23/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Moya
import Alamofire

enum SurveyAPIProvider: TargetType {
    
    case authenticate(userName:String,password:String)
    
}
extension SurveyAPIProvider {
    public var baseURL: URL { return URL(string: "https://nimbl3-survey-api.herokuapp.com/")! }
    
    public var path: String {
        switch self {
        case .authenticate: return "oauth/token"
        }
    }
    
    public var method: Moya.Method {
        switch self {
           default: return .get
        }
    }
    
    public var validate: Bool {
        return false
    }
    
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    public var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        default: return JSONEncoding.default
        }
    }
    
    public var task: Task {
        switch self {
        default:
            guard let params = parameters else { return .requestPlain }
            return .requestParameters(parameters: params, encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        switch self {
          default: return nil
        }
    }
    
        
}

extension SurveyAPIProvider: XAuthAuthorizable {
    
    public var shouldXAuthAuthorize: Bool {
        switch self {
        default: return true
        }
    }
    
}


