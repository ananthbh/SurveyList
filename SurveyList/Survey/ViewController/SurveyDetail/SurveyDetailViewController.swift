//
//  SurveyDetailViewController.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import UIKit

struct SurveyDetailScreenTransitions {
    let onBackButtonTapped: EmptyClosureType
}

class SurveyDetailViewController: UIViewController {

    
    private var viewModel: SurveyDetailViewModel!
    private var transitions: SurveyDetailScreenTransitions!
    
    convenience init(viewModel: SurveyDetailViewModel, transitions: SurveyDetailScreenTransitions) {
        self.init()
        self.viewModel = viewModel
        self.transitions = transitions
    }
    
    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayLabel.text = viewModel.displayEmptyText
        setupLeftBarButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupLeftBarButton() {
        let barButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Back Arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        barButton.tintColor = #colorLiteral(red: 0.05882352941, green: 0.05882352941, blue: 0.05882352941, alpha: 1)
        navigationItem.leftBarButtonItem = barButton
    }
    
    @objc func backButtonAction() {
        self.transitions.onBackButtonTapped()
    }
    
    

}
