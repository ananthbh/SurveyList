//
//  SurveyDetailViewModel.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Foundation


final class SurveyDetailViewModel {
    
    let provider: NetworkProvider!
    let survey: Survey!
    
    init(survey: Survey, provider: NetworkProvider) {
        self.provider = provider
        self.survey = survey
    }
    
    var displayEmptyText: String {
        return "Welcome to \(survey.name)"
    }
}
