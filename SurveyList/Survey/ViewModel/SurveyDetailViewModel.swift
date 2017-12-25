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
    
    init(provider: NetworkProvider) {
        self.provider = provider
    }
    
    var displayEmptyText: String {
        return "Welcome to Survey Detail Screen"
    }
}
