//
//  ModeViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/23.
//

import UIKit
import RxSwift
import RxCocoa

class ModeViewController: BaseViewController {

    @IBOutlet var btnGoInsert: UIButton!
    @IBOutlet var btnGoRandom: UIButton!
    @IBOutlet var btnGoSearch: UIButton!
    @IBOutlet var btnGoMore: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var placeItems = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlaceList()
        self.title = "모드"
    }
    
    private func setupUI() {
        btnGoInsert.backgroundColor = .themeColor
        btnGoInsert.setTitle("직접 골라", for: .normal)
        btnGoInsert.setTitleColor(.whiteColor, for: .normal)
        btnGoInsert.layer.cornerRadius = 10
        
        btnGoRandom.backgroundColor = .themeColor
        btnGoRandom.setTitle("랜덤 골라", for: .normal)
        btnGoRandom.setTitleColor(.whiteColor, for: .normal)
        btnGoRandom.layer.cornerRadius = 10
        
        btnGoSearch.backgroundColor = .themeColor
        btnGoSearch.setTitle("검색", for: .normal)
        btnGoSearch.setTitleColor(.whiteColor, for: .normal)
        btnGoSearch.layer.cornerRadius = 10
        
        btnGoMore.backgroundColor = .themeColor
        btnGoMore.setTitle("더보기", for: .normal)
        btnGoMore.setTitleColor(.whiteColor, for: .normal)
        btnGoMore.layer.cornerRadius = 10
    }
    
    private func setupTapEvent() {
        btnGoInsert.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "InsertViewController") as? InsertViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnGoRandom.rx.tap
            .bind {
                ItemViewModel.shared.randomEventItems.accept(self.placeItems)
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Result") as? ResultViewController else { return }
                vc.isRandom = true
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnGoSearch.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchViewController") as? SearchViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnGoMore.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MoreViewController") as? MoreViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func getPlaceList() {
        if let coord = LocationManager.shared.myLocation {
            let code = "FD6"
            KakaoMapManager.shared.rxGetPlace(mandatoryParam: code, lat: "\(coord.latitude)", lon: "\(coord.longitude)", type: .category)
                .map({ (items) -> [Place] in
                    return items!.sorted(by: { $0.distance < $1.distance })
                })
                .subscribe(onNext: { data in
                    self.placeItems.removeAll()
                    data.forEach { data in
                        self.placeItems.append(data)
                    }
                }).disposed(by: disposeBag)
        }
    }
}
