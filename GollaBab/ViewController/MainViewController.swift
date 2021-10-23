//
//  ViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/12.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        setUI()
        setTapEvent()
        CoreDataManager.shared.showDetail()
        LocationManager.shared.getLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setUI() {
        lblTitle.textColor = .themeColor
        
        btnStart.backgroundColor = .themeColor
        btnStart.setTitle("시작", for: .normal)
        btnStart.setTitleColor(.whiteColor, for: .normal)
        btnStart.layer.cornerRadius = 10
        
        btnHistory.backgroundColor = .themeColor
        btnHistory.setTitle("지난 투표", for: .normal)
        btnHistory.setTitleColor(.whiteColor, for: .normal)
        btnHistory.layer.cornerRadius = 10
    }

    private func setTapEvent() {
        btnStart.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ModeViewController") as? ModeViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnHistory.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
}

