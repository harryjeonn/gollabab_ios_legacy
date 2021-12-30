//
//  ViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/12.
//

import UIKit
import RxSwift
import RxCocoa
import GoogleMobileAds
import Alamofire

class MainViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnHistory: UIButton!
    @IBOutlet var btnCalendar: UIButton!
    @IBOutlet var btnEasterEgg: UIButton!
    @IBOutlet var easterEggView: UIView!
    @IBOutlet var easterEggTitle: UILabel!
    @IBOutlet var easterEggDesc: UILabel!
    
    private let disposeBag = DisposeBag()
    
    private var interstitial: GADInterstitialAd?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTapEvent()
        CoreDataManager.shared.showDetail()
        LocationManager.shared.checkPermission()
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        loadInterstitial()
    }
    
    private func checkResultCount() {
        guard let resultCount = UserDefaults.standard.value(forKey: "resultCount") as? Int else { return }
        print("resultCount = \(resultCount)")
        if resultCount % 10 == 0 {
            print("show admob")
            UserDefaults.standard.set(resultCount + 1, forKey: "resultCount")
            showInterstitial()
        }
    }
    
    private func setUI() {
        lblTitle.textColor = .themeColor
        
        btnStart.backgroundColor = .themeColor
        btnStart.setTitle("시작", for: .normal)
        btnStart.setTitleColor(.whiteColor, for: .normal)
        btnStart.layer.cornerRadius = 10
        
        btnHistory.backgroundColor = .themeColor
        btnHistory.setTitle("저장한 투표", for: .normal)
        btnHistory.setTitleColor(.whiteColor, for: .normal)
        btnHistory.layer.cornerRadius = 10
        
        btnCalendar.backgroundColor = .themeColor
        btnCalendar.setTitle("먹계부", for: .normal)
        btnCalendar.setTitleColor(.whiteColor, for: .normal)
        btnCalendar.layer.cornerRadius = 10
        
        btnEasterEgg.setTitle("", for: .normal)
        btnEasterEgg.backgroundColor = .clear
        
        easterEggView.backgroundColor = .themeColor
        easterEggView.layer.cornerRadius = 10
        easterEggView.isHidden = true
        
        easterEggTitle.textColor = .whiteColor
        easterEggDesc.textColor = .whiteColor
    }

    private func setTapEvent() {
        var count = 0
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
        
        btnCalendar.rx.tap
            .bind {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController else { return }
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        btnEasterEgg.rx.tap
            .bind {
                count += 1
                if count == 23 {
                    print("easter egg!!")
                    UserDefaults.standard.set(true, forKey: "easterEgg")
                    self.showAnimation()
                }
            }.disposed(by: disposeBag)
    }
    
    private func showAnimation() {
        UIView.transition(with: easterEggView, duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
            self.easterEggView.isHidden = false
        })
        perform(#selector(hideAnimation), with: nil, afterDelay: 1.5)
    }
    
    @objc private func hideAnimation() {
        UIView.transition(with: easterEggView, duration: 1.0,
                          options: .transitionCrossDissolve,
                          animations: {
            self.easterEggView.isHidden = true
        })
    }
    
    // MARK: - 전면 광고
    private func loadInterstitial() {
        // 테스트 ID = ca-app-pub-3940256099942544/4411468910
        // 실제 ID = ca-app-pub-6497545219748270/9414609028
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-6497545219748270/9414609028", request: request) { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self
            checkResultCount()
        }
    }
    
    private func showInterstitial() {
        if let interstitial = interstitial {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn`t ready")
        }
    }
}

extension MainViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }
    
    /// Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did present full screen content.")
    }
    
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad did dismiss full screen content.")
        loadInterstitial()
    }
}
