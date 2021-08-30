//
//  HistoryData.swift
//  GollaBab
//
//  Created by 전현성 on 2021/08/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfHistoryData {
    var header: String
    var items: [Item]
}

extension SectionOfHistoryData: SectionModelType {
    typealias Item = HistoryItem
    
    init(original: SectionOfHistoryData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct HistoryItem {
    var title: String
    var date: String
}

class HistoryViewModel {
    static let shared = HistoryViewModel()
    
    var disposeBag = DisposeBag()
    
    var history = BehaviorRelay<[SectionOfHistoryData]>(value: [])
    
    var title: String!
    var result: String!
    var items: [String]!
    
    func convertHistory(_ history: [History]) -> [SectionOfHistoryData] {
        var convertedData = [SectionOfHistoryData]()
        var date = [String]()
        let reversedHistory = history.reversed()
        
        reversedHistory.enumerated().forEach { index, his in
            guard let currentDate = his.date,
                  let currentTitle = his.title else { return }
            if index == 0 || !date.contains(currentDate) {
                convertedData.append(SectionOfHistoryData(header: "\(currentDate)", items: [HistoryItem(title: currentTitle, date: currentDate)]))
            } else {
                convertedData.append(SectionOfHistoryData(header: "", items: [HistoryItem(title: currentTitle, date: currentDate)]))
            }
            date.append(currentDate)
        }
        return convertedData
    }
}
