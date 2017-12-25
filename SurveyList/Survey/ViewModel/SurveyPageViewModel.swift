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
    func fetchSurveys(page: Int, completion:@escaping () -> ())
    func removeAllSurveys()
}

class SurveyPageViewModelImpl: SurveyPageViewModel {
    
    let provider: NetworkProvider
    
    fileprivate var surveys: [Survey] = []
    
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    func fetchSurveys(page: Int, completion:@escaping () -> ()) {
        self.provider.request(.surveys(page: page)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let surveys = try response.map([Survey].self)
                    self.surveys.append(contentsOf: surveys)
                    completion()
                } catch {
                    completion()
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
    
    func removeAllSurveys() {
        surveys = []
    }
    
}
