//
//  SearchHistoryViewModel.swift
//  GollaBab
//
//  Created by 전현성 on 2021/11/24.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfSearchHistoryData {
    var header: String
    var items: [Item]
}

extension SectionOfSearchHistoryData: SectionModelType {
    typealias Item = SearchHistoryItem
    
    init(original: SectionOfSearchHistoryData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct SearchHistoryItem {
    var title: String
    var date: Date
}

class SearchHistoryViewModel {
    static let shared = SearchHistoryViewModel()
    
    var disposeBag = DisposeBag()
    
    var searchHistory = BehaviorRelay<[SectionOfSearchHistoryData]>(value: [])
    
    var title: String?
    
    func loadSearchHistory() {
        let searchHistory = CoreDataManager.shared.loadSearchHistory()
        var data = [SectionOfSearchHistoryData]()
        var items = [SearchHistoryItem]()
        
        CoreDataManager.shared.deleteAllSearchHistory()
        
        searchHistory.enumerated().forEach { index, his in
            guard let title = his.title,
                  let date = his.date else { return }
            
            if index < 15 {
                if items.contains(where: { $0.title == title }) {
                    items.removeAll(where: { $0.title == title })
                }
                items.insert(SearchHistoryItem(title: title, date: date), at: 0)
            }
        }
        
        items.forEach { item in
            CoreDataManager.shared.saveSearchHistory(item: item.title, date: item.date)
        }
        
        data.append(SectionOfSearchHistoryData(header: "최근 검색", items: items))
        self.searchHistory.accept(data)
    }
}
