//
//  MapViewController.swift
//  JhTabProject
//
//  Created by Jh's MacbookPro on 2019/12/20.
//  Copyright © 2019 JH. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputText.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //位置を検索し、キーボードを閉じる
        textField.resignFirstResponder()
        //テキストフィールドから入力した場所を取得する
        if let searchKey = textField.text{
            print(searchKey)
            
            //CLインスタンスを生成する
            let geocoder = CLGeocoder()
            
            //入力した場所から位置情報を取得する
            geocoder.geocodeAddressString(searchKey, completionHandler: {(MKPlacemark,
               Error) in
                
                //位置情報が存在する場合unwrapPlaceMarksを取得する
                if let unwrapPlaceMarks = MKPlacemark{
                    //一番目の情報を取得する
                    if let firstPlaceMark = unwrapPlaceMarks.first{
                        //位置情報を取得する
                        if let location = firstPlaceMark.location{
                            //位置情報から緯度経度をtargetcoodinateに設定する
                            let targetcoordinate = location.coordinate
                            //緯度経度をデバックエリアに出力する
                            print(targetcoordinate)
                            
                            //MKPointAnnotationインスタンスを生成する
                            let pin = MKPointAnnotation()
                            //pinを設定する場所に緯度経度を設定
                            pin.coordinate = targetcoordinate
                            //pinに検索した場所を名前として設定する
                            pin.title = searchKey
                            //pinをマップに設定する
                            self.map.addAnnotation(pin)
                            //検索した緯度経度を中心に半径500m範囲内を表示
                            self.map.region = MKCoordinateRegion(center: targetcoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                    }
                }else{
                    let alert = UIAlertController(title: "error", message: "検索した場所はありません。", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "確認", style: .default)
                    alert.addAction(ok)
                    self.present(alert, animated: false)
                }
            })
        }
        return true
    }
    @IBAction func changeMap(_ sender: Any){
        if map.mapType == .standard{
            map.mapType = .hybrid
        }
        else if map.mapType == .hybrid{
            map.mapType = .hybridFlyover
        }
        else if map.mapType == .hybridFlyover{
            map.mapType = .mutedStandard
        }
        else if map.mapType == . mutedStandard{
            map.mapType = .standard
        }
    }

}
