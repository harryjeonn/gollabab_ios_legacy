//
//  SetSearchRangeViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/25.
//

import UIKit
import RxSwift
import RxCocoa

class SetSearchRangeViewController: BaseViewController {

    @IBOutlet var slider: UISlider!
    @IBOutlet var textField: UITextField!
    @IBOutlet var lblDistancsUnit: UILabel!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var successView: UIView!
    @IBOutlet var lblSuccess: UILabel!
    
    private let disposeBag = DisposeBag()
    private let userDefault = UserDefaults.standard
    
    private var range: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextField()
        setupSlider()
        setupTapEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "검색범위 설정"
    }
    
    private func setupUI() {
        lblDistancsUnit.font = UIFont(name: "EliceDigitalBaeumOTF", size: 15)
        lblDistancsUnit.textColor = .themeColor
        
        textField.font = UIFont(name: "EliceDigitalBaeumOTF", size: 15)
        
        slider.tintColor = .themeColor
        
        btnSave.backgroundColor = .themeColor
        btnSave.setTitle("저장", for: .normal)
        btnSave.setTitleColor(.whiteColor, for: .normal)
        btnSave.layer.cornerRadius = 10
        
        successView.backgroundColor = .themeColor
        successView.layer.cornerRadius = 10
        successView.isHidden = true
        
        lblSuccess.font = UIFont(name: "EliceDigitalBaeumOTF", size: 15)
        lblSuccess.textColor = .whiteColor
    }
    
    private func setupTextField() {
        range = userDefault.float(forKey: "searchRange")
        if range == 0 {
            range = 300
        }
        textField.text = "\(range)"
        
        textField.rx.text
            .orEmpty
            .subscribe(onNext: { text in
                self.slider.value = (text as NSString).floatValue
                self.range = self.slider.value
            }).disposed(by: disposeBag)
    }
    
    private func setupSlider() {
        slider.minimumValue = 0
        slider.maximumValue = 1000
        
        slider.rx.value
            .subscribe(onNext: { value in
                self.updateValue()
                self.textField.text = "\(Int(value))"
            }).disposed(by: disposeBag)
    }
    
    private func updateValue() {
        let interval = 100
        let intervalValue = Int(self.slider.value / Float(interval) ) * interval
        slider.value = Float(intervalValue)
        range = slider.value
    }
    
    private func showAnimation() {
        UIView.transition(with: successView, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.successView.isHidden = false
        })
        perform(#selector(hideAnimation), with: nil, afterDelay: 1.5)
    }
    
    @objc private func hideAnimation() {
        UIView.transition(with: successView, duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: {
            self.successView.isHidden = true
        })
    }
    
    private func setupTapEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnSave.rx.tap
            .bind {
                guard let text = self.textField.text,
                      let value = Int(text) else { return }
                if value > 1000 {
                    self.lblSuccess.text = "1000m 이하로 설정해주세요"
                } else {
                    self.userDefault.set(self.range, forKey: "searchRange")
                    self.lblSuccess.text = "저장되었습니다"
                }
                self.showAnimation()
            }.disposed(by: disposeBag)
    }
}
