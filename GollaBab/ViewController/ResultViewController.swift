//
//  ResultViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/31.
//

import UIKit
import RxSwift
import RxCocoa

enum ButtonShowType {
    case animation
    case result
    case retry
    case random
    case empty
}

class ResultViewController: BaseViewController {
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet var lblCategory: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnGoHome: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet var btnShowPlace: UIButton!
    
    private let disposeBag = DisposeBag()
    private var items = [String]()
    private var randomItems = [Place]()
    private var timer: Timer!
    var isRandom: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupItems()
        setupTapEvent()
        startAnimation()
        checkItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "결과"
    }
    
    private func checkItems() {
        if isRandom ?? false {
            if randomItems.isEmpty == true {
                setupEmptyView()
            }
        } else {
            if items.isEmpty == true {
                setupEmptyView()
            }
        }
    }
    
    private func setupEmptyView() {
        timer.invalidate()
        changeButton(.empty)
        lblResult.text = "투표할 항목이 없어요🥲"
    }
    
    private func setupUI() {
        changeButton(.animation)
        
        lblResult.backgroundColor = .clear
        lblResult.textColor = .themeColor
        lblResult.font = UIFont(name: "EliceDigitalBaeumOTF", size: 17)
        
        lblCategory.text = ""
        lblCategory.textColor = .themeColor
        lblCategory.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
        
        btnGoHome.backgroundColor = .themeColor
        btnGoHome.layer.cornerRadius = 10
        btnGoHome.setTitleColor(.whiteColor, for: .normal)
        
        btnSave.backgroundColor = .themeColor
        btnSave.layer.cornerRadius = 10
        btnSave.setTitleColor(.whiteColor, for: .normal)
        
        btnStop.backgroundColor = .themeColor
        btnStop.layer.cornerRadius = 10
        btnStop.setTitleColor(.whiteColor, for: .normal)
        
        btnRetry.backgroundColor = .themeColor
        btnRetry.layer.cornerRadius = 10
        btnRetry.setTitleColor(.whiteColor, for: .normal)
        
        btnShowPlace.backgroundColor = .themeColor
        btnShowPlace.layer.cornerRadius = 10
        btnShowPlace.setTitleColor(.whiteColor, for: .normal)
        
        if isRandom ?? false {
            btnShowPlace.setTitle("위치", for: .normal)
        }
    }
    
    func setupItems() {
        ItemViewModel.shared.eventItems
            .subscribe(onNext: { items in
                self.items = items
            }).disposed(by: disposeBag)
        
        ItemViewModel.shared.randomEventItems
            .subscribe(onNext: { items in
                self.randomItems = items
            }).disposed(by: disposeBag)
    }
    
    private func changeButton(_ type: ButtonShowType) {
        switch type {
        case .animation, .retry:
            btnStop.isHidden = false
            btnSave.isHidden = true
            btnRetry.isHidden = true
            btnGoHome.isHidden = true
            btnShowPlace.isHidden = true
            lblCategory.isHidden = true
        case .result:
            btnStop.isHidden = true
            btnSave.isHidden = false
            btnRetry.isHidden = false
            btnGoHome.isHidden = false
            btnShowPlace.isHidden = false
            lblCategory.isHidden = false
        case .random:
            btnStop.isHidden = true
            btnSave.isHidden = false
            btnRetry.isHidden = false
            btnGoHome.isHidden = false
            btnShowPlace.isHidden = true
            lblCategory.isHidden = false
        case .empty:
            btnStop.isHidden = true
            btnSave.isHidden = true
            btnRetry.isHidden = true
            btnGoHome.isHidden = false
            lblCategory.isHidden = false
            btnShowPlace.isHidden = true
        }
    }
    
    private func setupTapEvent() {
        btnStop.rx.tap
            .bind {
                self.timer.invalidate()
                self.randomResult()
                self.changeButton(.result)
            }.disposed(by: disposeBag)
        
        btnGoHome.rx.tap
            .bind {
                self.navigationController?.popToRootViewController(animated: true)
            }.disposed(by: disposeBag)
        
        btnSave.rx.tap
            .bind {
                if self.isRandom ?? false {
                    HistoryViewModel.shared.items = self.randomTitles()
                } else {
                    HistoryViewModel.shared.items = self.items
                }
                
                HistoryViewModel.shared.result = self.lblResult.text
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaveAlertViewController") as? SaveAlertViewController  else { return }
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.setValue(vc, forKey: "contentViewController")
                self.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        btnRetry.rx.tap
            .bind {
                self.removeItems()
                self.startAnimation()
                self.changeButton(.animation)
            }.disposed(by: disposeBag)
        
        btnShowPlace.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
                vc.query = self.lblResult.text
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func removeItems() {
        if isRandom ?? false {
            self.randomItems.removeAll(where: { $0.placeName == self.lblResult.text })
        } else {
            self.items.removeAll(where: { $0 == self.lblResult.text })
        }
    }
    
    private func randomTitles() -> [String] {
        var titleItems = [String]()
        self.randomItems.forEach { place in
            titleItems.append(place.placeName)
        }
        
        return titleItems
    }
    
    //MARK: - Animation
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.randomResult()
        })
    }
    
    private func randomResult() {
        self.lblResult.animate(0.2)
        if isRandom ?? false {
            guard let randomItem = self.randomItems.randomElement() else { return }
            self.lblResult.text = randomItem.placeName
            self.lblCategory.text = randomItem.categoryName
        } else {
            guard let item = self.items.randomElement() else { return }
            self.lblResult.text = "\(item)"
        }
    }

}

extension UIView {
    func animate(_ duration:CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .push
        animation.subtype = .fromTop
        animation.duration = duration
        
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
