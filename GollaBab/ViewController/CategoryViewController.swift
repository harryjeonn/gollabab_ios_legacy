//
//  CategoryViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2022/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: BaseViewController {
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var stackView: UIStackView!
    
    @IBOutlet var koreanButton: UIButton!
    @IBOutlet var westernButton: UIButton!
    @IBOutlet var chineseButton: UIButton!
    @IBOutlet var japaneseButton: UIButton!
    @IBOutlet var casualButton: UIButton!
    @IBOutlet var fastfoodButton: UIButton!
    @IBOutlet var cafeButton: UIButton!
    @IBOutlet var asianButton: UIButton!
    @IBOutlet var snackButton: UIButton!
    @IBOutlet var randomButton: UIButton!
    
    @IBOutlet var startButton: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var keywordButtons = [UIButton]()
    private var placeItems = [Place]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTapEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "카테고리"
    }
    
    private func setupUI() {
        descriptionLabel.text = "검색할 카테고리를 선택해주세요"
        descriptionLabel.font = UIFont(name: "EliceDigitalBaeumOTF", size: 17)
        descriptionLabel.textColor = .themeColor
        
        koreanButton.setTitle("한식", for: .normal)
        westernButton.setTitle("양식", for: .normal)
        chineseButton.setTitle("중식", for: .normal)
        japaneseButton.setTitle("일식", for: .normal)
        casualButton.setTitle("분식", for: .normal)
        fastfoodButton.setTitle("패스트푸드", for: .normal)
        cafeButton.setTitle("카페", for: .normal)
        asianButton.setTitle("아시아음식", for: .normal)
        snackButton.setTitle("간식", for: .normal)
        randomButton.setTitle("랜덤", for: .normal)
        
        stackView.subviews.forEach { view in
            view.subviews.forEach { button in
                guard let button = button as? UIButton else { return }
                
                button.setTitleColor(.themeColor, for: .normal)
                button.layer.borderWidth = 2
                button.layer.borderColor = UIColor.themeColor.cgColor
                button.layer.cornerRadius = 5
                button.titleLabel?.font = UIFont(name: "EliceDigitalBaeumOTF", size: 15)
                
                keywordButtons.append(button)
            }
        }
        
        startButton.setTitle("시작", for: .normal)
        startButton.backgroundColor = .themeColor
        startButton.layer.cornerRadius = 10
        startButton.setTitleColor(.whiteColor, for: .normal)
    }
    
    private func setupTapEvent() {
        keywordButtons.forEach { button in
            button.rx.tap
                .bind {
                    if button.backgroundColor == .themeColor {
                        button.backgroundColor = .clear
                        button.setTitleColor(.themeColor, for: .normal)
                    } else {
                        button.backgroundColor = .themeColor
                        button.setTitleColor(.whiteColor, for: .normal)
                    }
                }.disposed(by: disposeBag)
        }
        
        startButton.rx.tap
            .bind {
                self.placeItems.removeAll()
                
                let selectedKeywords = self.checkSelected()
                
                if selectedKeywords.isEmpty == false {
                    selectedKeywords.forEach { keyword in
                        if let lastKeyword = selectedKeywords.last,
                           lastKeyword == keyword {
                            self.getPlaceList(keyword: keyword, isLast: true)
                        } else {
                            self.getPlaceList(keyword: keyword, isLast: false)
                        }
                    }
                }
            }.disposed(by: disposeBag)
    }
    
    private func checkSelected() -> [String] {
        var selectedKeywords = [String]()
        
        keywordButtons.forEach { button in
            if button.backgroundColor == .themeColor {
                if let keyword = button.titleLabel?.text {
                    selectedKeywords.append(keyword)
                }
            }
        }
        return selectedKeywords
    }
    
    private func getPlaceList(keyword: String, isLast: Bool) {
        var param = keyword
        var type = SearchType.keyword
        
        if keyword == "랜덤" {
            param = "FD6"
            type = .category
        }
        
        if let coord = LocationManager.shared.myLocation {
            KakaoMapManager.shared.rxGetPlace(mandatoryParam: param, lat: "\(coord.latitude)", lon: "\(coord.longitude)", type: type)
                .map({ (items) -> [Place] in
                    return items!.sorted(by: { $0.distance < $1.distance })
                })
                .subscribe(onNext: { data in
                    data.forEach { data in
                        self.placeItems.append(data)
                    }
                    if isLast == true {
                        ItemViewModel.shared.randomEventItems.accept(self.placeItems)
                        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "Result") as? ResultViewController else { return }
                        vc.isRandom = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }).disposed(by: disposeBag)
        }
    }
}
