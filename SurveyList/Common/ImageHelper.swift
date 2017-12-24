//
//  ImageHelper.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//

import AlamofireImage

final class ImageHelper {
    
    static func imageRequest(_ survey: Survey) -> URLRequest {
        let urlString = survey.coverImage + "l"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        return request
    }
}
