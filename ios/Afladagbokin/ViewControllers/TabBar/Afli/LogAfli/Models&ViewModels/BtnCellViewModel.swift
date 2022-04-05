// The MIT License (MIT)
//
// Copyright (c) 2022 Stokkur Software ehf.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import ReactiveKit
import Bond

enum BtnCellType{
    
    case sleppt
    case undirmal
    case gutted
}

class BtnCellViewModel{

    let titleText = Observable<String>("")
    let btnLeftText = Observable<String>("")
    let btnRightText = Observable<String>("")

    let isBtnSelected = Observable<Bool>(false)
    
    let type: BtnCellType
    
    init(type: BtnCellType){
        self.type = type
        setup()
    }
    
    func setup(){
        
        switch type {
        case .sleppt:
            titleText.value = "Lönduð eða sleppt"
            btnLeftText.value = "Sleppt"
            btnRightText.value = "Lönduð"
        case .undirmal:
            titleText.value = "Undirmál?"
            btnLeftText.value = "Nei"
            btnRightText.value = "Já"
        case .gutted:
            titleText.value = "Slægður?"
            btnLeftText.value = "Óslægður"
            btnRightText.value = "Slægður"
        }
    }
    
    func changeToEnabled(){
        isBtnSelected.value = true
        
    }
    
    func changeToDisabled(){
        isBtnSelected.value = false
    }
}
