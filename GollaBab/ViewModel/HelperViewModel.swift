//
//  HelperViewModel.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/31.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SectionOfHelper {
    var header: String
    var items: [Item]
}

extension SectionOfHelper: SectionModelType {
    typealias Item = HelperType
    
    init(original: SectionOfHelper, items: [HelperType]) {
        self = original
        self.items = items
    }
}

enum HelperType {
    case directly
    case random
    case search
    case map
    case searchRange
    
    func title() -> String {
        switch self {
        case .directly:
            return "직접 골라"
        case .random:
            return "랜덤 골라"
        case .search:
            return "검색"
        case .map:
            return "지도"
        case .searchRange:
            return "검색범위 설정"
        }
    }
    
    func description() -> String {
        switch self {
        case .directly:
            return "직접 투표할 내용을 입력하여 무작위로 투표합니다."
        case .random:
            return "주변 식당을 무작위로 투표합니다."
        case .search:
            return "검색할 키워드를 입력한 후 주변 검색을 시작합니다."
        case .map:
            return "검색결과가 지도에 표시됩니다.\n말풍선을 터치하면 해당 장소의 정보가 사파리 혹은 카카오앱으로 열립니다."
        case .searchRange:
            return "검색할 범위를 설정합니다.\n기본 검색범위는 300m이며, 1000m까지 지원합니다."
        }
    }
}

class HelperViewModel {
    static let shared = HelperViewModel()
    
    private let disposeBag = DisposeBag()
    
    var helperItems = BehaviorRelay<[SectionOfHelper]>(value: [])
    
    func loadHelperList() {
        var helperList = [SectionOfHelper]()
        
        helperList.append(SectionOfHelper(header: "", items: [.directly, .random, .search, .map, .searchRange]))
        
        helperItems.accept(helperList)
    }
}

