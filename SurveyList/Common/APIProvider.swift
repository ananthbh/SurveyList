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
    
    case authenticate
    case surveys
    
}
extension SurveyAPIProvider {
    public var baseURL: URL { return URL(string: "https://nimbl3-survey-api.herokuapp.com/")! }
    
    public var path: String {
        switch self {
        case .authenticate: return "oauth/token"
        case .surveys: return "surveys.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .authenticate: return .post
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
        
        case .authenticate:
            var params = [String: Any]()
            params["grant_type"] = "password"
            params["username"] = "carlos@nimbl3.com"
            params["password"] = "antikera"
            return params
        case .surveys:
            var params = [String:Any]()
            params["page"] = 1
            params["per_page"] = 3
            return params
        default:
            return nil
        }
    }

    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .authenticate: return URLEncoding.default
        default: return URLEncoding.default
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
        case  .authenticate: return false
        default: return true
        }
    }
    
}


