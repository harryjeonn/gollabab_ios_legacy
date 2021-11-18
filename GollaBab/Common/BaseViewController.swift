//
//  BaseViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/07/18.
//

import UIKit
import GoogleMobileAds

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupBackgroundColor()
        if UserDefaults.standard.bool(forKey: "easterEgg") != true {
            addBannerView()
        }
        LocationManager.shared.getLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    private func setupBackgroundColor() {
        view.backgroundColor = .bgColor
    }
    
    // MARK: - Navigation
    
    private func setupNaviBar() {
        guard let titleFont: UIFont = UIFont(name: "EliceDigitalBaeumOTF-Bd", size: 15) else { return }
        navigationController?.navigationBar.tintColor = .themeColor
        navigationController?.navigationBar.barTintColor = .bgColor
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font : titleFont,
            NSAttributedString.Key.foregroundColor : UIColor.themeColor
        ]
        navigationItem.backButtonTitle = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btn_home"), style: .plain, target: self, action: #selector(goHome))
    }
    
    // MARK: - Admob
    
    private func addBannerView() {
        guard let vc = topViewController() else { return }
        if vc is MapViewController {
            return
        }
        let adSize = GADAdSizeFromCGSize(CGSize(width: vc.view.frame.width, height: 50))
        
        let bannerView = GADBannerView(adSize: adSize)
        bannerView.backgroundColor = .clear
        // 실제 광고 : ca-app-pub-6497545219748270/9648511964
        // 테스트 광고 : ca-app-pub-3940256099942544/6300978111
        bannerView.adUnitID = "ca-app-pub-6497545219748270/9648511964"
        bannerView.rootViewController = vc
        bannerView.load(GADRequest())
        bannerView.delegate = self
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        vc.view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.leadingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor),
            bannerView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
            
        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topViewController(base: selected)
            
        } else if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    // MARK: - Selector
    
    @objc func goHome() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension BaseViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }
    
    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
}
