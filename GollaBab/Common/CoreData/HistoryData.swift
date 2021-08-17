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
    typealias Item = String
    
    init(original: SectionOfHistoryData, items: [String]) {
        self = original
        self.items = items
    }
}

class HistoryData {
    static let shared = HistoryData()
    
    var disposeBag = DisposeBag()
    
    var title: String!
    var result: String!
    var items: [String]!
}
