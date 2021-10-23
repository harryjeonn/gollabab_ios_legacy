//
//  MoreViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/23.
//

import UIKit
import RxSwift
import RxCocoa

class MoreViewController: BaseViewController {
    
    @IBOutlet var tableView: UITableView!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "더보기"
    }
    
    private func setupUI() {
        tableView.backgroundColor = .bgColor
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "MoreCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "moreCell")
        // TODO: - 업데이트를 지속적으로 한다면 버전명, 버전정보 추가
        let items = Observable.of(["검색범위 설정", "인앱결제", "오픈소스", /*"버전명",*/ "앱리뷰", "도움말"])
        
        items.bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, item: String) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "moreCell") as! MoreCell
            cell.lblTitle.text = item
                
            return cell
        }.disposed(by: disposeBag)
    }
}
