//
//  HistoryDetailViewModel.swift
//  GollaBab
//
//  Created by 전현성 on 2021/09/02.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfHistoryDetailData {
    var header: String
    var items: [Item]
}

extension SectionOfHistoryDetailData: SectionModelType {
    typealias Item = String
    
    init(original: SectionOfHistoryDetailData, items: [Item]) {
        self = original
        self.items = items
    }
}

class HistoryDetailViewModel {
    static let shared = HistoryDetailViewModel()
    
    var disposeBag = DisposeBag()
    
    var historyDetailData = BehaviorRelay<[SectionOfHistoryDetailData]>(value: [])
    
    func loadHistoryDetail() {
        var sections = [SectionOfHistoryDetailData]()
        
        CoreDataManager.shared.selectResult
            .subscribe(onNext: { result in
                sections.append(SectionOfHistoryDetailData(header: "결과", items: [result]))
                self.historyDetailData.accept(sections)
            }).disposed(by: disposeBag)
        
        CoreDataManager.shared.selectItem
            .subscribe(onNext: { items in
                sections.append(SectionOfHistoryDetailData(header: "항목", items: items))
                self.historyDetailData.accept(sections)
            }).disposed(by: disposeBag)
    }
}
