// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import Foundation

struct TourModelList{
    
    static let historyKey = "history"
    static let totalPagesKey = "totalPages"
    static let totalElementsKey = "totalElements"
    
    public var historyList: [TourModel] = []
    public var totalPages: Int = 0
    public var totalElements: Int = 0
}

extension TourModelList: JSONInitable {
    init?(json: JSON) {
        
        guard let historyElementList = json[TourModelList.historyKey] as? [JSON] else{
            return nil
        }
        
        guard let totalPages = json[TourModelList.totalPagesKey] as? Int else{
            return nil
        }
        
        guard let totalElementsKey = json[TourModelList.totalElementsKey] as? Int else{
            return nil
        }
        
        self.historyList = historyElementList.flatMap { TourModel(json: $0) }
        self.totalPages = totalPages
        self.totalElements = totalElementsKey
    }
}
