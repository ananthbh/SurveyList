//
//  SurveyPageViewController.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import UIKit

protocol PageContentViewController {
    var pageIndex: Int { get set }
}

struct SurveyPageViewTransitions {
    let handleTakeSurveyButtonTap: EmptyClosureType
}

class SurveyPageViewController: UIPageViewController {

    private var viewModel: SurveyPageViewModel!
    private var transitions: SurveyPageViewTransitions!
    private var currentPage = 0
    private var isFetchingSurveys = false
    var page = 1
    
    convenience init(viewModel:SurveyPageViewModel, transitions: SurveyPageViewTransitions) {
        self.init(transitionStyle: .scroll,
                  navigationOrientation: .vertical,
                  options: nil)
        self.viewModel = viewModel
        self.transitions = transitions
        currentPage = 0
        dataSource = self
        delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.showHUD()
        fetchSurveys(page: page) {
            self.hideHUD()
            self.setupNavigationbarandButtons()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func surveyViewController(_ viewModel: SurveyViewModel) -> SurveyViewController {
        let transitions = SurveyViewTransitions(onTakeSurveyButtonTapped: {
            self.transitions.handleTakeSurveyButtonTap()
        })
        let surveyViewController = SurveyViewController(viewModel: viewModel, transitions: transitions)
        return surveyViewController
    }
    
    func viewControllerAtIndex(_ index:Int) -> UIViewController {
        let surveyViewModel = self.viewModel.viewModel(at: index)
        let controller = surveyViewController(surveyViewModel)
        controller.pageIndex = index
        return controller
    }
    
    func setupNavigationbarandButtons() {
        let leftBarButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        let rightBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburger"), style: .plain, target: self, action: nil)
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
        
    }
    
    @objc func reload() {
        if isFetchingSurveys { return }
        isFetchingSurveys = true
        self.showHUD()
        self.viewModel.removeAllSurveys()
        self.currentPage = 0
        fetchSurveys(page: 1){
            self.hideHUD()
            self.isFetchingSurveys = false
        }
    }
    
    func fetchSurveys(page: Int, completion:@escaping () -> ()) {
        viewModel.fetchSurveys(page: page) {
            let controller = self.viewControllerAtIndex(self.currentPage)
            self.setViewControllers([controller], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
            completion()
        }
    }

}

extension SurveyPageViewController: HUDRenderer { }

extension SurveyPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! PageContentViewController
        var index = vc.pageIndex
        if (index == 0 || index == NSNotFound) {
            return nil
        }
        index = index - 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! PageContentViewController
        var index = vc.pageIndex as Int
        if (index == NSNotFound) {
            return nil
        }
        index = index + 1
        if (index == viewModel.numberOfSurveys) {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return viewModel.numberOfSurveys
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

extension SurveyPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if !completed { return }
        if let controller = pageViewController.viewControllers?.last as? PageContentViewController {
            currentPage = controller.pageIndex
            print("currentPage: \(currentPage)")
            if viewModel.numberOfSurveys - currentPage == 3 {
                print("will fetch now")
                self.page += 1
                self.fetchSurveys(page: page, completion: {
                    print("done fetching new surveys")
                })
            }
        }
    }
    
}

