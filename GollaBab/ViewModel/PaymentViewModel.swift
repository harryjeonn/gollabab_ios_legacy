//
//  PaymentViewModel.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfPayment {
    var header: String
    var items: [Item]
}

extension SectionOfPayment: SectionModelType {
    typealias Item = PaymentType
    
    init(original: SectionOfPayment, items: [PaymentType]) {
        self = original
        self.items = items
    }
}

enum PaymentType {
    case removeAdmob
    case support
    
    func title() -> String {
        switch self {
        case .removeAdmob:
            return "광고 제거"
        case .support:
            return "후원"
        }
    }
    
    func image() -> String {
        switch self {
        case .removeAdmob:
            return "광고제거 이미지"
        case .support:
            return "후원 이미지"
        }
    }
    
    func description() -> String {
        switch self {
        case .removeAdmob:
            return "광고제거 설명"
        case .support:
            return "후원 설명"
        }
    }
}

class PaymentViewModel {
    static let shared = PaymentViewModel()
    
    private let disposeBag = DisposeBag()
    
    var paymentItems = BehaviorRelay<[SectionOfPayment]>(value: [])
    
    func loadPaymentList() {
        var paymentList = [SectionOfPayment]()
        
        paymentList.append(SectionOfPayment(header: PaymentType.removeAdmob.title(), items: [.removeAdmob]))
        paymentList.append(SectionOfPayment(header: PaymentType.support.title(), items: [.support]))
        
        paymentItems.accept(paymentList)
    }
}
