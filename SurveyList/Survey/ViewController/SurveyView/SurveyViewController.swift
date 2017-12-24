//
//  SurveyViewController.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import UIKit

struct SurveyViewTransitions {
    
}


class SurveyViewController: UIViewController {

    var viewModel: SurveyViewModel!
    var transitions: SurveyViewTransitions!
    
    convenience init(viewModel: SurveyViewModel,
                     transitions: SurveyViewTransitions) {
        self.init()
        self.viewModel = viewModel
        self.transitions = transitions
    }
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var takeSurveyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.fetchSurveys()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
