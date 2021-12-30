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
    case history
    case map
    case searchRange
    case calendar
    case other
    
    func title() -> String {
        switch self {
        case .directly:
            return "직접 골라"
        case .random:
            return "랜덤 골라"
        case .search:
            return "검색"
        case .history:
            return "저장한 투표"
        case .map:
            return "지도"
        case .searchRange:
            return "검색범위 설정"
        case .calendar:
            return "먹계부"
        case .other:
            return "기타"
        }
    }
    
    func description() -> String {
        switch self {
        case .directly:
            return "직접 투표할 내용을 입력하여 무작위로 투표해요."
        case .random:
            return "주변 식당을 무작위로 투표해요."
        case .search:
            return "검색할 키워드를 입력한 후 주변 검색을 시작해요."
        case .history:
            return "저장한 투표를 볼 수 있어요.\n리스트 항목을 터치하면 상세화면으로 이동해요."
        case .map:
            return "검색결과가 지도에 표시돼요.\n말풍선을 터치하면 해당 장소의 정보가 사파리로 열려요."
        case .searchRange:
            return "검색할 범위를 설정해요.\n기본 검색범위는 300m이며, 1000m까지 지원해요."
        case .calendar:
            return "먹은 것을 기록할 수 있어요.\n우측 하단에 + 버튼을 눌러 추가해보세요!"
        case .other:
            return "리스트 항목을 왼쪽으로 밀면 삭제할 수 있어요."
        }
    }
}

class HelperViewModel {
    static let shared = HelperViewModel()
    
    private let disposeBag = DisposeBag()
    
    var helperItems = BehaviorRelay<[SectionOfHelper]>(value: [])
    
    func loadHelperList() {
        var helperList = [SectionOfHelper]()
        
        helperList.append(SectionOfHelper(header: "", items: [.directly, .random, .search, .history, .map, .searchRange, .calendar, .other]))
        
        helperItems.accept(helperList)
    }
}

