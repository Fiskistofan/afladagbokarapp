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
import ReactiveKit
import Bond

enum VCType{
    
    case lina
    case handfaeri
}

class LinaAndHandfaeriViewModel{
    
    let txtFieldTextTop = Observable<String?>("")
    let txtFieldTextBot = Observable<String?>("")
    let type: VCType
    let vcTitle = Observable<String>("")
    let txtFieldTopHasNumber = Observable<Bool>(false)
    let txtFieldBotHasNumber = Observable<Bool>(false)
    let hasEnteteredValuesForBoth = Observable<Bool>(false)
    
    init(type: VCType){
        self.type = type
        
        if type == .lina{
            vcTitle.value = "Hvernig lína?"
        }
        else{
            vcTitle.value = "Hvernig handfæri?"
        }
        
        _ = txtFieldTextTop.observeNext{ value in
            let textNumber = value ?? ""
            self.txtFieldTopHasNumber.value = Int(textNumber) ?? 0 > 0
        }
        
        _ = txtFieldTextBot.observeNext{ value in
            let textNumber = value ?? ""
            self.txtFieldBotHasNumber.value = Int(textNumber) ?? 0 > 0
        }
        
        combineLatest(txtFieldTopHasNumber, txtFieldBotHasNumber).map { $0 && $1 }.bind(to: hasEnteteredValuesForBoth)
    }
}
