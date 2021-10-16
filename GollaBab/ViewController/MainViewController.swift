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
    @IBOutlet var btnRandomPlace: UIButton!
    
    private let disposeBag = DisposeBag()
    private var placeItems = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()        
        setUI()
        setTapEvent()
        CoreDataManager.shared.showDetail()
        LocationManager.shared.getLocation()
        getPlaceList()
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
        
        btnRandomPlace.backgroundColor = .themeColor
        btnRandomPlace.setTitle("랜덤", for: .normal)
        btnRandomPlace.setTitleColor(.whiteColor, for: .normal)
        btnRandomPlace.layer.cornerRadius = 10
    }

    private func setTapEvent() {
        btnStart.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "InsertViewController") as? InsertViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnHistory.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "HistoryViewController") as? HistoryViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnRandomPlace.rx.tap
            .bind {
                ItemViewModel.shared.eventItems.accept(self.placeItems)
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Result") as? ResultViewController else { return }
                vc.isRandom = true
                vc.setupItems()
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func getPlaceList() {
        if let coord = LocationManager.shared.myLocation {
            let query = "식당"
            KakaoMapManager.shared.rxGetPlace(query: query, lat: "\(coord.latitude)", lon: "\(coord.longitude)")
                .map({ (items) -> [Place] in
                    return items!.sorted(by: { $0.distance < $1.distance })
                })
                .subscribe(onNext: { data in
                    data.forEach { data in
                        self.placeItems.append(data.placeName)
                    }
                }).disposed(by: disposeBag)
        }
    }
    
}

