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
    
    var surveyPageViewModel: SurveyPageViewModel!
    
    init(rootController: UINavigationController, networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
        self.rootController = rootController
        let surveyController = surveyPageViewController()
        rootController.setViewControllers([surveyController], animated: true)
    }
    
    func surveyPageViewController() -> SurveyPageViewController {
        let viewModel = SurveyPageViewModelImpl(provider: self.networkProvider)
        let transitions = SurveyPageViewTransitions(handleTakeSurveyButtonTap: surveyDetailViewController)
        self.surveyPageViewModel = viewModel
        let surveyPageViewController = SurveyPageViewController(viewModel: viewModel, transitions: transitions)
        return surveyPageViewController
    }
    
    func surveyDetailViewController(_ survey: Survey) {
        let viewModel = SurveyDetailViewModel(survey: survey, provider: self.networkProvider)
        let transitions = SurveyDetailScreenTransitions(onBackButtonTapped: {
            self.rootController.popViewController(animated: true)
        })
        let surveyDetailViewController = SurveyDetailViewController(viewModel: viewModel, transitions: transitions)
        self.rootController.pushViewController(surveyDetailViewController, animated: true)
    }
    
    
}
