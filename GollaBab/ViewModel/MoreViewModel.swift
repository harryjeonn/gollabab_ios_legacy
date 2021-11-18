//
//  MoreViewModel.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/25.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfMore {
    var header: String
    var items: [Item]
}

extension SectionOfMore: SectionModelType {
    typealias Item = MoreType
    
    init(original: SectionOfMore, items: [MoreType]) {
        self = original
        self.items = items
    }
}

enum MoreType {
    case searchRange
    case inAppPayment
    case openSource
    case appReview
//    case version // 유지보수한다면 버전명 추가
    case helper
    
    func title() -> String {
        switch self {
        case .searchRange:
            return "검색범위 설정"
        case .inAppPayment:
            return "인앱결제"
        case .openSource:
            return "오픈소스"
        case .appReview:
            return "앱 리뷰"
        case .helper:
            return "도움말"
        }
    }
}

class MoreViewModel {
    static let shared = MoreViewModel()
    
    var disposeBag = DisposeBag()
    
    var moreItems = BehaviorRelay<[SectionOfMore]>(value: [])
    
    func loadMoreList() {
        var moreList = [SectionOfMore]()
        
        moreList.append(SectionOfMore(header: "", items: [.searchRange/*, .inAppPayment*/, .openSource, .appReview, .helper]))
        
        moreItems.accept(moreList)
    }
}
