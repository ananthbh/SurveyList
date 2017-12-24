//
//  SurveyCoordinator.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 23/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import Foundation
import UIKit

final class SurveyCoordinator {
    
    private let networkProvider: NetworkProvider!
    private let rootController: UINavigationController!
    
    var surveyViewModel: SurveyViewModel!
    
    init(rootController: UINavigationController, networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
        self.rootController = rootController
        let surveyController = surveyViewController()
        rootController.setViewControllers([surveyController], animated: true)
    }
    
    func surveyViewController() -> SurveyViewController {
        let viewModel = SurveyViewModel(provider: self.networkProvider)
        let transitions = SurveyViewTransitions()
        self.surveyViewModel = viewModel
        let surveyViewController = SurveyViewController(viewModel: viewModel, transitions: transitions)
        return surveyViewController
    }
    
    
}
