//
//  NetworkProvider.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 23/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Moya
import RxSwift

final class NetworkProvider: MoyaProvider<SurveyAPIProvider>, Service {
    
    private var credentialsProvider:CredentialsProvider
    
    var сancellableRequest: Cancellable?
    var onUserTokenDied: EmptyClosureType?
    
    init(credentialsProvider: CredentialsProvider,
         stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
         plugins: [PluginType] = []) {
        self.credentialsProvider = credentialsProvider
        super.init(stubClosure: stubClosure,
                   plugins: plugins)
    }
    
    @discardableResult
    override func request(_ target: SurveyAPIProvider,
                          callbackQueue: DispatchQueue? = .none,
                          progress: ProgressBlock? = .none,
                          completion: @escaping Completion) -> Cancellable {
        guard credentialsProvider.tokenExpired else { return proceedRequest(target, completion: completion) }
        return super.request(.authenticate, completion: { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try response.mapJSON() as! [String:Any]
                    if let token = json["access_token"] as? String,
                        let expires = json["expires_in"] as? Double, let created = json["created_at"] as? Double, let tokenType = json["token_type"] as? String {
                        self.credentialsProvider.token = token
                        self.credentialsProvider.expires = expires
                        self.credentialsProvider.createdAt = created
                        self.credentialsProvider.tokenType = tokenType
                        self.credentialsProvider.saveCredentials()
                        self.proceedRequest(target, completion: completion)
                    } else {
                        if response.statusCode == 401 {
                            self.procceedUserTokenDied()
                        } else {
                            completion(.failure(MoyaError.jsonMapping(response)))
                        }
                    }
                } catch {
                    if response.statusCode == 401 {
                        self.procceedUserTokenDied()
                    } else {
                        completion(.failure(MoyaError.underlying(error,response)))
                    }
                }
            case .failure(let error):
                completion(.failure(MoyaError.underlying(error,nil)))
            }
        })
    }
    
    @discardableResult
    fileprivate func proceedRequest(_ target: SurveyAPIProvider, completion: @escaping Completion) -> Cancellable {
        
        return super.request(target, completion: { (result) in
            switch result {
            case .success(let response):
                if response.statusCode == 401 {
                    self.procceedUserTokenDied()
                }
            case .failure(let error):
                if let response = error.response,
                    response.statusCode == 401 {
                    self.procceedUserTokenDied()
                }
            }
            completion(result)
        })
    }
    
    private func procceedUserTokenDied() {
        guard let diedClosure = onUserTokenDied else { return }
  //      User.clear()
        credentialsProvider.clearCredentials()
        diedClosure()
        self.onUserTokenDied = nil
    }
    
    
}

