//
//  ItemViewModel.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/22.
//

import RxSwift
import RxCocoa

class ItemViewModel {
    static let shared = ItemViewModel()
    
    private let disposeBag = DisposeBag()
    var eventItems = BehaviorRelay<[String]>(value: [])
    var items = PublishSubject<[String]>()
    
    var randomEventItems = BehaviorRelay<[Place]>(value: [])
    var randomItems = PublishSubject<[Place]>()
    
    func rxInit() {
        items.subscribe(onNext: { items in
            self.eventItems.accept(items)
        }).disposed(by: disposeBag)
        
        randomItems.subscribe(onNext: { items in
            self.randomEventItems.accept(items)
        }).disposed(by: disposeBag)
    }
}
