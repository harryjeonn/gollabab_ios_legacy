//
//  CalendarViewModel.swift
//  GollaBab
//
//  Created by 전현성 on 2021/12/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfCalendarData {
    var header: String
    var items: [Item]
}

extension SectionOfCalendarData: SectionModelType {
    typealias Item = CalendarItem
    
    init(original: SectionOfCalendarData, items: [Item]) {
        self = original
        self.items = items
    }
}

struct CalendarItem {
    var date: Date
    var title: String
    var memo: String
}

class CalendarViewModel {
    static let shared = CalendarViewModel()
    
    private let disposeBag = DisposeBag()
    
    var calendarData = BehaviorRelay<[SectionOfCalendarData]>(value: [])
    
    var date: Date!
    var title: String!
    var memo: String?
    
    func saveCalendarData() {
        CoreDataManager.shared.saveCalendarData(date: date, title: title, memo: memo)
        loadCalendarData(date)
    }
    
    func loadCalendarData(_ todayDate: Date) {
        var loadDatas = [SectionOfCalendarData]()
        
        let datas = CoreDataManager.shared.loadCalendarData(todayDate)
        datas.forEach { data in
            guard let date = data.date,
                  let title = data.title,
                  let memo = data.memo else { return }
            
            let formatDate = formatDate(date)
            
            if formatDate == todayDate {
                loadDatas.append(SectionOfCalendarData(header: "", items: [CalendarItem(date: date, title: title, memo: memo)]))
            }
        }
        
        calendarData.accept(loadDatas)
    }
    
    func deleteCalendarData(date: Date, title: String, memo: String) {
        let datas = CoreDataManager.shared.loadCalendarData(date)
        datas.enumerated().forEach { index, data in
            if data.date == date && data.title == title && data.memo == memo {
                CoreDataManager.shared.deleteCalendarData(index: index, date: date)
            }
        }
    }
    
    func formatDate(_ date: Date) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: date)
        let formatDate = dateFormatter.date(from: stringDate)
        
        return formatDate
    }
}
