//
//  SurveyViewModel.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Foundation


class SurveyViewModel {
    
    let provider: NetworkProvider
    
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    func fetchSurveys() {
        self.provider.request(.surveys) { (result) in
            switch result {
            case .success(let response):
                do {
                    let surveys = try response.map([Survey].self)
                    print("the surveys are \(surveys)")
                } catch {
                    print("failed fetching surveys")
                }
            case .failure(let error):
                print("failed fetched surveys")
            }
        }
    }
    
}
