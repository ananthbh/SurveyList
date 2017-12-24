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

class SurveyPageViewController: UIPageViewController {

    private var viewModel: SurveyPageViewModel!
    private var currentPage = 0
    
    convenience init(viewModel:SurveyPageViewModel) {
        self.init(transitionStyle: .scroll,
                  navigationOrientation: .vertical,
                  options: nil)
        self.viewModel = viewModel
        currentPage = 0
        dataSource = self
        delegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchSurveys {
            let controller = self.viewControllerAtIndex(self.currentPage)
            self.setViewControllers([controller], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func surveyViewController(_ viewModel: SurveyViewModel) -> SurveyViewController {
        let transitions = SurveyViewTransitions()
        let surveyViewController = SurveyViewController(viewModel: viewModel, transitions: transitions)
        return surveyViewController
    }
    
    func viewControllerAtIndex(_ index:Int) -> UIViewController {
        let surveyViewModel = self.viewModel.viewModel(at: index)
        let controller = surveyViewController(surveyViewModel)
        controller.pageIndex = index
        return controller
    }

}


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
        }
    }
    
    
}

