//
//  Survey.swift
//  SurveyList
//
//  Created by Ananth Bhamidipati on 24/12/17.
//  Copyright © 2017 Ananth Bhamidipati. All rights reserved.
//


struct Survey {
    let coverImage     : String
    let name           : String
    let description    : String
}

extension Survey: Decodable {
    enum SurveyKeys: String, CodingKey {
        case coverImage  = "cover_image_url"
        case name        = "title"
        case description = "description"
    }
    
    init(from decoder: Decoder) throws  {
        let container = try decoder.container(keyedBy: SurveyKeys.self)
        
        coverImage  = try container.decode(String.self, forKey: .coverImage)
        name        = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        
    }
    
}
