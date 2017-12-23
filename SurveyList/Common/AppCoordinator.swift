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
            uSelf.startAuthFlow()
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
        
    }
    
    fileprivate func startAuthFlow() {
        
    }
}
