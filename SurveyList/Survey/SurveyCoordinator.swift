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
    
    init(rootController: UINavigationController, networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
        self.rootController = rootController
    }
    
    
}
