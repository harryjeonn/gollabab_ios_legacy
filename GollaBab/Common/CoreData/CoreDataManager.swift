//
//  CoreData.swift
//  GollaBab
//
//  Created by 전현성 on 2021/08/17.
//

import Foundation
import CoreData
import RxSwift

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    private let disposeBag = DisposeBag()
    
    let HistoryModelName = "History"
    let searchHistoryModelName = "SearchHistory"
    
    var isSuccess = BehaviorSubject<Bool>(value: false)
    var deleteRow = PublishSubject<Int>()
    var selectRow = PublishSubject<Int>()
    var selectItem = BehaviorSubject<[String]>(value: [])
    var selectResult = BehaviorSubject<String>(value: "")
    
    // MARK: - History
    func saveHistory() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.string(from: now)
        
        let historyData = HistoryViewModel.shared
        
        guard let context = context else { return }
        let history: History = NSEntityDescription.insertNewObject(forEntityName: HistoryModelName, into: context) as! History
        
        history.date = date
        guard let title = historyData.title,
              let items = historyData.items,
              let result = historyData.result else {
            isSuccess.onNext(false)
            return
        }
        history.title = title
        history.items = items
        history.result = result

        do {
            try context.save()
            isSuccess.onNext(true)
            print("save history")
        } catch let err as NSError {
            print("error: \(err.userInfo)")
            isSuccess.onNext(false)
        }
    }
    
    func loadHistory() -> [History] {
        var history = [History]()
        do {
            let res = try context?.fetch(History.fetchRequest()) as! [History]
            history = res
            print("load history")
        } catch {
            print(error.localizedDescription)
        }
        
        return history
    }
    
    func deleteHistory(_ section: Int) {
        let history = loadHistory().reversed()[section] as NSManagedObject
        context?.delete(history)
        do {
            try context?.save()
            let convertedData = HistoryViewModel.shared.convertHistory(CoreDataManager.shared.loadHistory())
            HistoryViewModel.shared.history.accept(convertedData)
            print("delete history")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showDetail() {
        selectRow.subscribe(onNext: { row in
            do {
                let res = try self.context?.fetch(History.fetchRequest()) as! [History]
                let reversedRes = res.reversed()
                reversedRes.enumerated().forEach { index, his in
                    if index == row {
                        guard let result = his.result else { return }
                        self.selectResult.onNext(result)
                        self.selectItem.onNext(his.items)
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }).disposed(by: disposeBag)
    }
    
    // MARK: - Search History
    func saveSearchHistory(item: String?, date: Date?) {        
        guard let context = context else { return }
        let searchHistory: SearchHistory = NSEntityDescription.insertNewObject(forEntityName: searchHistoryModelName, into: context) as! SearchHistory
        
        searchHistory.title = item
        searchHistory.date = date
        do {
            try context.save()
            print("save Search History")
        } catch let err as NSError {
            print("error: \(err.userInfo)")
        }
    }
    
    func loadSearchHistory() -> [SearchHistory] {
        var searchHistory = [SearchHistory]()
        do {
            let fetchRequest = SearchHistory.fetchRequest()
            let sortDate = NSSortDescriptor.init(key: "date", ascending: true)
            fetchRequest.sortDescriptors = [sortDate]
            let res = try context?.fetch(fetchRequest) as! [SearchHistory]
            searchHistory = res
            print("load searchHistory")
        } catch {
            print(error.localizedDescription)
        }
        
        return searchHistory
    }
    
    func deleteSearchHistory(_ section: Int) {
        
    }
    
    func deleteAllSearchHistory() {
        guard let context = context else { return }
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: searchHistoryModelName)
        let deleteReq: NSBatchDeleteRequest = NSBatchDeleteRequest.init(fetchRequest: fetchRequest)
        
        do {
            let deleteRes = try context.execute(deleteReq)
            try context.save()
            print("delete result : \(deleteRes)")
        } catch let error as NSError {
            print("delete err : \(error), \(error.userInfo)")
        }
    }
}
