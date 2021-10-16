//
//  MapViewController.swift
//  GollaBab
//
//  Created by 전현성 on 2021/09/13.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MapViewController: BaseViewController {
    @IBOutlet var contentsView: UIView!
    @IBOutlet var btnMoveMyLocation: UIButton!
    
    private let disposeBag = DisposeBag()
    
    private var mapView: MTMapView?
    private var arrPin = [MTMapPOIItem]()
    private var arrPlace = [Place]()
    var query: String?
    
    private lazy var bottomSheetPanStartingTopConstant: CGFloat = bottomSheetPanMinTopConstant
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    private var bottomSheetPanMinTopConstant: CGFloat = 30.0
    private var defaultHeight: CGFloat = 300
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .bgColor
        
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    private let dragIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .themeColor
        view.layer.cornerRadius = 3
        return view
    }()
    
    var items = BehaviorRelay<[Place]>(value: [])
    private let tableView: UITableView = {
        let tableview = UITableView()
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "주변 식당"
        setBtn()
        LocationManager.shared.getLocation()
        getPlaceList()
        rxTableView()
    }
    
    private func getPlaceList() {
        if let coord = LocationManager.shared.myLocation,
           let query = query {
            KakaoMapManager.shared.rxGetPlace(query: query, lat: "\(coord.latitude)", lon: "\(coord.longitude)")
                .map({ (items) -> [Place] in
                    return items!.sorted(by: { $0.distance < $1.distance })
                })
                .subscribe(onNext: { data in
                    self.arrPlace = data
                    self.setPin(data)
                    self.items.accept(data)
                    self.drawMap()
                    self.initView()
                }).disposed(by: disposeBag)
        }
    }
    
    private func initView() {
        setLayout()
        showBottomSheet(atState: .mini)
        panGesture()
    }
    
    // MARK: - Layout
    private func setLayout() {
        guard let mapView = mapView else { return }
        mapView.addSubview(bottomSheetView)
        view.addSubview(dragIndicatorView)
        bottomSheetView.addSubview(tableView)
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint,
        ])
        
        dragIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dragIndicatorView.widthAnchor.constraint(equalToConstant: 60),
            dragIndicatorView.heightAnchor.constraint(equalToConstant: dragIndicatorView.layer.cornerRadius * 2),
            dragIndicatorView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            dragIndicatorView.bottomAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 20)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor)
        ])
    }
    
    //MARK: - TableView
    private func rxTableView() {
        tableView.backgroundColor = .bgColor
        tableView.register(PlaceCell.self, forCellReuseIdentifier: "cell")
        
        items
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: PlaceCell.self)) { row, item, cell in
                cell.selectionStyle = .none
                cell.img.image = UIImage(named: "noImage")
                cell.lblPlaceName.text = item.placeName
                cell.lblAddressName.text = item.addressName
                cell.lblDistance.text = "\(item.distance)m"
                if item.phone == "" {
                    cell.lblPhone.text = "전화번호가 없어요🥲"
                } else {
                    cell.lblPhone.text = item.phone
                }
            }.disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .subscribe(onNext: { index in
                let pin = self.arrPin[index.row]
                self.mapView?.select(pin, animated: true)
                self.mapView?.setMapCenter(pin.mapPoint, animated: true)
                self.showBottomSheet(atState: .mini)
            }).disposed(by: disposeBag)
    }
    
    //MARK: - Map
    private func setBtn() {
        guard let myLocation = LocationManager.shared.myLocation else { return }
        btnMoveMyLocation.layer.cornerRadius = btnMoveMyLocation.frame.width / 2
        btnMoveMyLocation.backgroundColor = .themeColor
        
        btnMoveMyLocation.rx.tap
            .bind {
                let coord = MTMapPointGeo(latitude: myLocation.latitude, longitude: myLocation.longitude)
                let point = MTMapPoint(geoCoord: coord)
                self.mapView!.setMapCenter(point, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func setPin(_ data: [Place]) {
        arrPin.removeAll()
        data.forEach { place in
            let pin = MTMapPOIItem()
            pin.itemName = place.placeName
            let coord = MTMapPointGeo(latitude: Double(place.latY)!, longitude: Double(place.lonX)!)
            pin.mapPoint = MTMapPoint(geoCoord: coord)
            pin.markerType = .yellowPin
            pin.showAnimationType = .springFromGround
            
            arrPin.append(pin)
        }
    }
    
    private func drawMap() {
        mapView = MTMapView(frame: self.view.bounds)
        
        if let mapView = mapView,
           let myLocation = LocationManager.shared.myLocation {
            mapView.delegate = self
            mapView.baseMapType = .standard
            mapView.showCurrentLocationMarker = true
            mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
            mapView.addPOIItems(arrPin)
            mapView.fitAreaToShowAllPOIItems()
            let coord = MTMapPoint(geoCoord: myLocation)
            mapView.setMapCenter(coord, animated: true)
            
            self.contentsView.insertSubview(mapView, at: 0)
        }
    }
    
    //MARK: - BottomSheet
    enum BottomSheetViewState {
        case expanded
        case normal
        case mini
    }
    
    private func panGesture() {
        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        
        // 제스처 딜레이 false
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        bottomSheetView.addGestureRecognizer(viewPan)
    }
    
    private func showBottomSheet(atState: BottomSheetViewState) {
        switch atState {
        case .expanded:
            bottomSheetViewTopConstraint.constant = bottomSheetPanMinTopConstant + 80
        case .normal:
            bottomSheetViewTopConstraint.constant = view.frame.height / 2
        case .mini:
            bottomSheetViewTopConstraint.constant = view.frame.height * (3 / 4)
        }
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func hideBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight - bottomPadding
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc private func viewPanned(_ panGestureRecgnizer: UIPanGestureRecognizer) {
        let translation = panGestureRecgnizer.translation(in: self.view)
        let velocity = panGestureRecgnizer.velocity(in: self.view)
        
        switch panGestureRecgnizer.state {
        case .began:
            bottomSheetPanStartingTopConstant = bottomSheetViewTopConstraint.constant
        case .changed:
            if bottomSheetPanStartingTopConstant + translation.y > bottomSheetPanMinTopConstant {
                bottomSheetViewTopConstraint.constant = bottomSheetPanStartingTopConstant + translation.y
            }
        case .ended:
            
            if velocity.y > 1500 {
                showBottomSheet(atState: .mini)
                return
            }
            
            let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
            let bottomPadding = view.safeAreaInsets.bottom
            
            if bottomSheetViewTopConstraint.constant < (safeAreaHeight + bottomPadding) * 0.25 {
                showBottomSheet(atState: .expanded)
            } else if self.bottomSheetViewTopConstraint.constant < (safeAreaHeight) - 70 {
                showBottomSheet(atState: .normal)
            } else {
                showBottomSheet(atState: .mini)
            }
        default:
            break
        }
    }
}

//MARK: - Delegate

extension MapViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        
    }
    
    func mapView(_ mapView: MTMapView!, touchedCalloutBalloonOf poiItem: MTMapPOIItem!) {
        arrPlace.forEach { place in
            if poiItem.itemName == place.placeName {
                if let url = URL(string: place.placeUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    func mapView(_ mapView: MTMapView?, updateDeviceHeading headingAngle: MTMapRotationAngle) {
        
    }
}
