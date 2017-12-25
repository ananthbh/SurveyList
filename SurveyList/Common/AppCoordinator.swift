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
        let authPlugin = XAuthTokenPlugin(tokenClosure: self.credentialsProvider.realToken)
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
            uSelf.checkAuthToken{}
        }
        return provider
    }()
    
    fileprivate var navigationController = UINavigationController()
    fileprivate var window: UIWindow
    
    fileprivate var currentSurveyCoordinator: SurveyCoordinator?
    
    public init(window: UIWindow) {
        self.window = window
        
        navigationController.view.backgroundColor = UIColor.white
        
        currentSurveyCoordinator = SurveyCoordinator(rootController: navigationController, networkProvider: networkProvider)
    
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        configureNavigationBar()
    }
    
    public func start() {
        
        if credentialsProvider.realToken != nil {
            enterApp()
            networkProvider.onUserTokenDied = { [weak self] in
                guard let uSelf = self else  { return }
                uSelf.checkAuthToken {
                    print("auth token fetched")
                }
            }
        } else {
            checkAuthToken { }
        }
    }
    
    private func enterApp() {
        currentSurveyCoordinator?.surveyPageViewController()
    }
    
    fileprivate func checkAuthToken(completion:@escaping () -> ()) {
        networkProvider.request(.authenticate) { (result) in
            switch result {
            case .success(let response):
                do {
                    let json = try response.mapJSON() as! [String:Any]
                    if let token = json["access_token"] as? String,
                        let expires = json["expires_in"] as? Double, let created = json["created_at"] as? Double, let tokenType = json["token_type"] as? String {
                        self.credentialsProvider.realToken = tokenType + " " + token
                        self.credentialsProvider.token = token
                        self.credentialsProvider.expires = expires
                        self.credentialsProvider.createdAt = created
                        self.credentialsProvider.tokenType = tokenType
                        self.credentialsProvider.saveCredentials()
                        self.enterApp()
                        completion()
                    }
                } catch {
                    print("failure in fetching auth token")
                }
            case .failure:
                print("failed in fetching data")
            }
        }
    }
    
    func configureNavigationBar() {
        let backgroundColor = UIColor(red: 20.0 / 255, green: 30.0 / 255, blue: 50.0 / 255, alpha: 1.0)
        let foregroundColor = UIColor.white
        UINavigationBar.appearance().barTintColor = backgroundColor
        UINavigationBar.appearance().tintColor = foregroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: foregroundColor]
        UILabel.appearance().backgroundColor = .clear
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = backgroundColor.withAlphaComponent(0.5)
        UINavigationBar.appearance().isTranslucent = true
    }
}
