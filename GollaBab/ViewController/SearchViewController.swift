//
//  SearchViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/10/23.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    @IBOutlet var textField: UITextField!
    @IBOutlet var btnSearch: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTextField()
        setupTapEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "검색"
        textField.text = nil
    }
    
    private func setupUI() {
        btnSearch.backgroundColor = .themeColor
        btnSearch.setTitle("검색", for: .normal)
        btnSearch.setTitleColor(.whiteColor, for: .normal)
        btnSearch.layer.cornerRadius = 10
        
        textField.textColor = .themeColor
        textField.font = UIFont(name: "EliceDigitalBaeumOTF", size: 14)
        textField.placeholder = "검색할 키워드를 입력해주세요."
    }
    
    private func setupTextField() {
        textField.rx
            .controlEvent([.editingDidEndOnExit])
            .subscribe(onNext: { _ in
                
            }).disposed(by: disposeBag)
    }
    
    private func setupTapEvent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        btnSearch.rx.tap
            .bind {
                if self.textField.text != nil && self.textField.text != "" {
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
                    vc.query = self.textField.text
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }.disposed(by: disposeBag)
    }
}
