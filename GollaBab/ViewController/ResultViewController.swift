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
}

class ResultViewController: BaseViewController {
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var btnGoHome: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnRetry: UIButton!
    @IBOutlet var btnShowPlace: UIButton!
    
    private let disposeBag = DisposeBag()
    private var items = [String]()
    private var timer: Timer!
    var isRandom: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupItems()
        setupTapEvent()
        startAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "결과"
    }
    
    private func setupUI() {
        changeButton(.animation)
        
        lblResult.backgroundColor = .clear
        
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
        
    }
    
    func setupItems() {
        ItemViewModel.shared.eventItems
            .subscribe(onNext: { items in
                self.items = items
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
        case .result:
            if isRandom ?? false {
                btnShowPlace.setTitle("위치", for: .normal)
            }
            btnStop.isHidden = true
            btnSave.isHidden = false
            btnRetry.isHidden = false
            btnGoHome.isHidden = false
            btnShowPlace.isHidden = false
        case .random:
            btnStop.isHidden = true
            btnSave.isHidden = false
            btnRetry.isHidden = false
            btnGoHome.isHidden = false
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
                HistoryViewModel.shared.items = self.items
                HistoryViewModel.shared.result = self.lblResult.text
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SaveAlertViewController") as? SaveAlertViewController  else { return }
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.setValue(vc, forKey: "contentViewController")
                self.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        btnRetry.rx.tap
            .bind {
                self.items.removeAll(where: { $0 == self.lblResult.text })
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
    
    //MARK: - Animation
    
    private func startAnimation() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { timer in
            self.randomResult()
        })
    }
    
    private func randomResult() {
        self.lblResult.animate(0.2)
        guard let item = self.items.randomElement() else { return }
        self.lblResult.text = "\(item)"
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
