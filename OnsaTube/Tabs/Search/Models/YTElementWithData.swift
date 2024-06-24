//
//  YTElementWithData.swift
//  OnsaTube
//
//  Created by Adem Özsayın on 20.06.2024.
//

import YouTubeKit

struct YTElementWithData {
    var id: Int? { self.element.id }
    
    var element: any YTSearchResult
    
    var data: YTElementDataSet
}
