//
//  AppCoordinator.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 23/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Moya


final class AppCoordinator {
    
    let credentialsProvider = CredentialsProvider()
    
    private lazy var networkProvider:NetworkProvider = {
        let loggerPlugin = NetworkLoggerPlugin(verbose: true,
                                               responseDataFormatter: JSONResponseDataFormatter)
        let authPlugin = XAuthTokenPlugin(tokenClosure: self.credentialsProvider.token)
        let plugins:[PluginType] = [authPlugin]
        let stubClosure:(SurveyAPIProvider) -> Moya.StubBehavior = { target in
            switch target {
            default: return .never
            }
        }
        let provider = NetworkProvider(credentialsProvider: credentialsProvider,
                                                stubClosure: stubClosure,
                                                plugins: plugins)
        provider.onUserTokenDied = { [weak self] in
            guard let uSelf = self else { return }
            uSelf.checkAuthToken()
        }
        return provider
    }()
    
    fileprivate var navigationController = UINavigationController()
    fileprivate var window: UIWindow
    
    public init(window: UIWindow) {
        self.window = window
        
        navigationController.view.backgroundColor = UIColor.white
        
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    public func start() {
        checkAuthToken()
    }
    
    fileprivate func checkAuthToken() {
        networkProvider.request(.authenticate) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as! [String:Any]
                    print("success json is \(json)")
                } catch {
                    print("failure in fetching auth token")
                }
            case .failure(let error):
                print("failed in fetching data")
            }
        }
    }
}
