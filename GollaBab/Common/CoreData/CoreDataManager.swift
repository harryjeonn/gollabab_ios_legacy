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
    
    let modelName = "History"
    
    var isSuccess = BehaviorSubject<Bool>(value: false)
    var deleteRow = PublishSubject<Int>()
    var selectRow = PublishSubject<Int>()
    var selectItem = BehaviorSubject<[String]>(value: [])
    var selectResult = BehaviorSubject<String>(value: "")
    
    func saveHistory() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.string(from: now)
        
        let historyData = HistoryViewModel.shared
        
        guard let context = context else { return }
        let history: History = NSEntityDescription.insertNewObject(forEntityName: modelName, into: context) as! History
        
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
}
