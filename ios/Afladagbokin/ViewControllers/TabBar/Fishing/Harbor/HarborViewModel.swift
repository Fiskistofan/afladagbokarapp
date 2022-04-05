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

class HarborViewModel {
    
    let selectedHarborId = Observable<Int>(0)
    let selectedHarborName = Observable<String>("")
    var selectedHarbor: PortModel? = nil
    var arrData = Observable<[PortModel]>([])
    let filteredData = Observable<[PortModel]>([])
    
    func fillData() {
        let ports = Session.manager.getPorts()
        arrData.value = ports.compactMap { PortModel(json: $0) }
       
        configureSelectedHarbor()
        configureTopFiveResults()
    }
    
    func configureSelectedHarbor(){
        
        guard let firstHarbor = arrData.value.first else {
            return
        }
        
        let lastHarborId = HarborManager.loadLastSelectedHarborId()
        guard lastHarborId != 0 else {
            
            self.selectedHarborId.value = firstHarbor.id
            self.selectedHarborName.value = firstHarbor.portName
            self.selectedHarbor = firstHarbor
            return
        }
        
        _ = arrData.value.map { harbor in
            if harbor.id == lastHarborId{
                self.selectedHarborId.value = harbor.id
                self.selectedHarborName.value = harbor.portName
                self.selectedHarbor = harbor
                return
            }
        }
    }
    
    func didSelectAtIndex(_ indexPath: IndexPath){
        
        selectedHarborId.value = filteredData.value[indexPath.row].id
        selectedHarborName.value = filteredData.value[indexPath.row].portName
        selectedHarbor = filteredData.value[indexPath.row]
        HarborManager.saveLastSelectedHarborId(selectedHarborId.value)
    }
    
    func configureTopFiveResults(){
        
        let mostPopularHarbors = HarborManager.getTopFiveMostPopularHarbors()
        var portsToReAdd: [PortModel] = []
        
        for harbor in mostPopularHarbors{
            
            if(!harbor.isEmpty){
                //These dictionaries only contain one key, the port ID as string
                //Therefore we can access the harbor key as the first key in the dictionary
                let harborKey = harbor.keys.first
                
                for index in stride(from: arrData.value.count - 1 , to: 0, by: -1){
                    let port = arrData.value[index]
                    if String(port.id) == harborKey{
                        portsToReAdd.append(arrData.value.item(at: index))
                        arrData.value.remove(at: index)
                    }
                }
            }
        }
        arrData.value.insert(contentsOf: portsToReAdd, at: 0)
        filteredData.value = arrData.value
    }
}
