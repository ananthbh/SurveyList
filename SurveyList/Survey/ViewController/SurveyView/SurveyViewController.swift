//
//  SurveyViewController.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import UIKit
import AlamofireImage
import RxSwift
import RxCocoa

struct SurveyViewTransitions {
    let onTakeSurveyButtonTapped: EmptyClosureType
}


class SurveyViewController: UIViewController, PageContentViewController {
    
    var pageIndex: Int = 0
    
    var viewModel: SurveyViewModel!
    var transitions: SurveyViewTransitions!
    
    private let disposeBag = DisposeBag()
    
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

        setSurveyName()
        setSurveyDescription()
        setSurveyCoverImage()
        setupTakeSurveyButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setSurveyName() {
        nameLabel.text = viewModel.surveyName
    }
    
    func setSurveyDescription() {
        descriptionLabel.text = viewModel.surveyDescription
    }
    
    func setSurveyCoverImage() {
        
        let filter = AspectScaledToFillSizeFilter(size: coverImage.frame.size)
        
        coverImage.af_setImage(withURLRequest: viewModel.coverImageRequest, placeholderImage: #imageLiteral(resourceName: "placeholder"), filter: filter, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), completion: nil)
    }
    
    func setupTakeSurveyButton() {
        takeSurveyButton.rx.tap.subscribe(onNext:{
            self.transitions.onTakeSurveyButtonTapped()
        }).disposed(by: disposeBag)
        
        takeSurveyButton.backgroundColor = UIColor.red
        takeSurveyButton.layer.cornerRadius = 10
        takeSurveyButton.setTitle("Take the Survey", for: .normal)
    }

    

}
