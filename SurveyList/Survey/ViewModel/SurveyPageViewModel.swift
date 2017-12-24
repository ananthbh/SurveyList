//
//  SurveyPageViewModel.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Foundation

protocol SurveyPageViewModel {
    func viewModel(at index:Int) -> SurveyViewModel
    var numberOfSurveys: Int { get }
    func fetchSurveys(completion:@escaping () -> ())
}

class SurveyPageViewModelImpl: SurveyPageViewModel {
    
    let provider: NetworkProvider
    
    fileprivate var surveys: [Survey] = []
    
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    func fetchSurveys(completion:@escaping () -> ()) {
        self.provider.request(.surveys) { (result) in
            switch result {
            case .success(let response):
                do {
                    let surveys = try response.map([Survey].self)
                    self.surveys = surveys
                    completion()
                    print("the surveys are \(surveys.count)")
                } catch {
                    print("failed fetching surveys")
                }
            case .failure:
                print("failed fetched surveys")
            }
        }
    }
    
    var numberOfSurveys: Int {
        return surveys.count
    }
    
    func viewModel(at index: Int) -> SurveyViewModel {
        let survey = surveys[index]
        let viewModel = SurveyViewModel(survey: survey, provider: self.provider)
        return viewModel
    }
    
}
