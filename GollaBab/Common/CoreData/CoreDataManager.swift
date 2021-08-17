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
    
    let modelName = "History"
    
    var isSuccess = BehaviorSubject<Bool>(value: false)
    
    func saveHistory() {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.string(from: now)
        
        let historyData = HistoryData.shared
        
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
    
    func loadHistory() {
        
    }
}
