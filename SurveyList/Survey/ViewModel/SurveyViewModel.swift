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
    
    var survey: Survey!
    
    init(survey:Survey, provider: NetworkProvider) {
        self.provider = provider
        self.survey = survey
    }
    
    var surveyName: String {
        get {
            return survey.name
        }
    }
    
    var surveyDescription: String {
        get {
            return survey.description
        }
    }
    
    var coverImageRequest: URLRequest {
        get {
            return ImageHelper.imageRequest(survey)
        }
    }
    
    
}
