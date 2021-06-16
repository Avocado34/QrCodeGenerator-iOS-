//
//  ViewController.swift
//  QRcodeGenerator
//
//  Created by 이승기 on 2020/10/03.
//

import UIKit
import QRCoder
import Photos
import Toast
import RxSwift
import RxCocoa
import StoreKit


class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Declarations
    var disposeBag = DisposeBag()
    
    var backgroundColorArr = Array<UIColor>()
    var foregroundColorArr = Array<UIColor>()
    var borderStyleArr = Array<UIImage>()
    
    @IBOutlet weak var backgrondColorCollectionView: UICollectionView!
    @IBOutlet weak var foregroundColorCollectionView: UICollectionView!
    @IBOutlet weak var borderStyleCollectionView: UICollectionView!
    
    @IBOutlet weak var appbarView: UIView!
    @IBOutlet weak var creditButton: UIButton!
    @IBOutlet weak var qrCodeContentView: UIView!
    @IBOutlet weak var sourceStringTextfield: UITextField!
    @IBOutlet weak var resultQrCodeImageView: UIImageView!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var qrCodeBoardView: UIView!
    
    @IBOutlet weak var bgColorSelectorView: UIView!
    @IBOutlet weak var bgColorPalleteButton: UIButton!
    
    @IBOutlet weak var fgColorSelectorView: UIView!
    @IBOutlet weak var fgColorPalleteButton: UIButton!
    
    @IBOutlet weak var qrCodeBorderImageView: UIImageView!
    @IBOutlet weak var borderStyleSelectorView: UIView!
    @IBOutlet weak var clearBorderStyleButton: UIButton!
    
    // export buttons
    @IBOutlet weak var exportBoardView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    // default values
    private var qrCodeSourceString = ""
    private var qrCodeBackgroundColor = UIColor.white
    private var qrCodeForegroundColor = UIColor.black
    
    // Color Picker
    private var selectedColor = UIColor.systemTeal
    private var colorPicker = UIColorPickerViewController()
    
    // to detect which button called
    private var isBgColorSelecting = true
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        initView()
        initInstance()
        initEventListener()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // MARK: - Overrides
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Initializations
    func initData(){
        backgroundColorArr.append(UIColor(named: "BackgroundColorSelection1")!)
        backgroundColorArr.append(UIColor(named: "BackgroundColorSelection2")!)
        backgroundColorArr.append(UIColor(named: "BackgroundColorSelection3")!)
        backgroundColorArr.append(UIColor(named: "BackgroundColorSelection4")!)
        backgroundColorArr.append(UIColor(named: "BackgroundColorSelection5")!)
        backgroundColorArr.append(UIColor(named: "BackgroundColorSelection6")!)
        
        foregroundColorArr.append(UIColor(named: "BackgroundColorSelection1")!)
        foregroundColorArr.append(UIColor(named: "BackgroundColorSelection2")!)
        foregroundColorArr.append(UIColor(named: "BackgroundColorSelection3")!)
        foregroundColorArr.append(UIColor(named: "BackgroundColorSelection4")!)
        foregroundColorArr.append(UIColor(named: "BackgroundColorSelection5")!)
        foregroundColorArr.append(UIColor(named: "BackgroundColorSelection6")!)
        
        borderStyleArr.append(UIImage(named: "BorderStyle1")!)
        borderStyleArr.append(UIImage(named: "BorderStyle2")!)
        borderStyleArr.append(UIImage(named: "BorderStyle3")!)
        borderStyleArr.append(UIImage(named: "BorderStyle4")!)
    }
    
    func initView(){
        
        // Appbar
        setRadius(view: appbarView, radius: 35)
        setShadow(view: appbarView, opacity: 0.2, shadowRadius: 15)
        appbarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        // Source data string TextField
        sourceStringTextfield.backgroundColor = UIColor.white
        setRadius(view: sourceStringTextfield, radius: 20)
        sourceStringTextfield.addLeftImage(UIImage(named: "QRcode")!, 20)
        
        
        // result Image
        setRadius(view: resultQrCodeImageView, radius: 7)
        
        // QRcode Board
        setRadius(view: qrCodeBoardView, radius: 15)
        setShadow(view: qrCodeBoardView, opacity: 0.2, shadowRadius: 15)
        
        // export baord view
        setRadius(view: exportBoardView, radius: 15)
        setShadow(view: exportBoardView, opacity: 0.2, shadowRadius: 15)
        
        // BakcgroundColor Board
        setRadius(view: bgColorSelectorView, radius: 15)
        setShadow(view: bgColorSelectorView, opacity: 0.2, shadowRadius: 15)
        
        // ForegroundColor Board
        setRadius(view: fgColorSelectorView, radius: 15)
        setShadow(view: fgColorSelectorView, opacity: 0.2, shadowRadius: 15)
        
        //BorderStyle Selector view
        setRadius(view: borderStyleSelectorView, radius: 15)
        setShadow(view: borderStyleSelectorView, opacity: 0.2, shadowRadius: 15)
        
        // Background Color picker Button
        setShadow(view: bgColorPalleteButton, opacity: 0.8, shadowRadius: 2)
        
        // Foreground Color picker Button
        setShadow(view: fgColorPalleteButton, opacity: 0.8, shadowRadius: 2)
        
        // set default qrcode border style
        qrCodeBorderImageView.image = UIImage()
    }
    
    func initInstance(){
        
        // source string textfield
        sourceStringTextfield.delegate = self
        sourceStringTextfield.returnKeyType = .done
        
        // color picker
        colorPicker.delegate = self
        
        // background color selector
        backgrondColorCollectionView.delegate = self
        backgrondColorCollectionView.dataSource = self
        
        // foreground color selector
        foregroundColorCollectionView.delegate = self
        foregroundColorCollectionView.dataSource = self
        
        // qrcode border style selector
        borderStyleCollectionView.delegate = self
        borderStyleCollectionView.dataSource = self
    }
    
    func initEventListener(){
        
        // source string input event
        sourceStringTextfield.rx.text
            .orEmpty
            .bind(with: self){ vc,text in
                vc.generateQRCode(text)
            }
            .disposed(by: disposeBag)
        
        // save button naction
        saveButton.rx.tap
            .bind(with: self){ vc,_ in
                vc.saveQrCode()
            }.disposed(by: disposeBag)
        
        // share button action
        shareButton.rx.tap
            .bind(with: self){ vc,_ in
                vc.shareQrCode()
            }.disposed(by: disposeBag)
        
        // background color picker button action
        bgColorPalleteButton.rx.tap
            .bind(with: self){ vc,_ in
                vc.isBgColorSelecting = true
                vc.showColorPicker(vc.qrCodeBackgroundColor)
            }.disposed(by: disposeBag)
        
        // foreground color picker button action
        fgColorPalleteButton.rx.tap
            .bind(with: self){ vc,_ in
                vc.isBgColorSelecting = false
                vc.showColorPicker(vc.qrCodeForegroundColor)
            }.disposed(by: disposeBag)
        
        // clear border style button action
        clearBorderStyleButton.rx.tap
            .bind(with: self){ vc,_ in
                vc.qrCodeBorderImageView.image = UIImage()
            }.disposed(by: disposeBag)
        
        
        // credit button tap action
        creditButton.rx.tap
            .bind(with: self){ vc,_ in
                vc.presentCreditVC()
            }.disposed(by: disposeBag)
        
        
        // qrCode view tap action
        qrCodeContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(qrCodeTap(_:))))
        
        // observing using app time
        Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    
    
    // MARK: - Methods
    func setShadow(view: UIView, opacity: Float, shadowRadius: CGFloat){
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = opacity
        view.layer.shadowRadius = shadowRadius
    }
    func setRadius(view: UIView, radius: CGFloat){
        view.layer.cornerRadius = radius
    }
    func setStroke(view: UIView, width: CGFloat){
        view.layer.borderWidth = width
        view.layer.borderColor = UIColor.white.cgColor
    }
    
    
    // Generate QRcode
    func generateQRCode(_ sourceString: String){
        qrCodeBorderImageView.image = qrCodeBorderImageView.image?.withRenderingMode(.alwaysTemplate)
        qrCodeBorderImageView.tintColor = qrCodeForegroundColor
        
        let qrCodeGenerator = QRCodeGenerator()
        qrCodeGenerator.correctionLevel = .H
        
        // set color
        qrCodeGenerator.backgroundColor = qrCodeBackgroundColor
        qrCodeGenerator.foregroundColor = qrCodeForegroundColor
        
        // generate QRcode
        let mQrCode = qrCodeGenerator.createImage(value: sourceString, size: CGSize(width: resultQrCodeImageView.bounds.width, height: resultQrCodeImageView.bounds.height), encoding: String.Encoding.utf8)

        resultQrCodeImageView.image = mQrCode
    }
    func showColorPicker(_ defaultColor: UIColor?){
        if #available(iOS 14.0, *){
            colorPicker.supportsAlpha = false
            
            // init defualt color
            if let defaultColor = defaultColor{
                colorPicker.selectedColor = defaultColor
            }
            
            present(colorPicker, animated: true)
        }else{
            self.view.makeToast("Color pallete is supported only on iOS 14.0 and later.")
        }
        
    }
    
    // Export Action
    func saveQrCode(){
        // request Album Permission
        if PHPhotoLibrary.authorizationStatus() != .authorized{
            // doesn't have aceess to album auth
            
            PHPhotoLibrary.requestAuthorization { (status) in
               // system permission request dialog
                if status == .authorized{
                    return
                }
            }
            
            // Present No Album auth alert
            DispatchQueue.main.async {
                self.presentNoAlbumAuthAlert()
            }
        }else{ // Album Access auth is permitted
            // Present Save Alert
            DispatchQueue.main.async {
                self.presentSaveToAlbumAlert()
            }
        }
    }
    
    func shareQrCode(){
        if let qrCode = captureQrCode(){
            let imageToShare = [qrCode]
            let activityVC = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad) {
                // if device is ipad
                activityVC.popoverPresentationController?.sourceView = shareButton!
                activityVC.popoverPresentationController?.sourceRect = (shareButton as AnyObject).bounds
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }else{
            self.view.makeToast("Please try again")
        }
    }
    
    
    func captureQrCode() -> UIImage?{
        
        // to remove corner radius on image
        setRadius(view: qrCodeBoardView, radius: 0)
        
        UIGraphicsBeginImageContextWithOptions(qrCodeBoardView.frame.size, false, 10)
        qrCodeBoardView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let qrCode = UIGraphicsGetImageFromCurrentImageContext()
        
        setRadius(view: qrCodeBoardView, radius: 15)
        
        return qrCode!
    }
    
    
    func presentSaveToAlbumAlert(){
        let dialog = UIAlertController(title: "SaveAlertTitle".localized, message: "SaveAlertMessage".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let qrCode = self.captureQrCode(){
                UIImageWriteToSavedPhotosAlbum(qrCode, nil, nil, nil)
            }else{
                self.view.makeToast("Please try again")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            // cancel Action
        }
        dialog.addAction(cancelAction)
        dialog.addAction(defaultAction)
        present(dialog, animated: true, completion: nil)
    }
    
    
    func presentNoAlbumAuthAlert(){
        let alert = UIAlertController(title: "AlbumAuthTitle".localized, message: "AlbumAuthMessage".localized, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // Open permission setting
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel button clicked")
        }
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func presentCreditVC(){
        guard let creditVC = storyboard?.instantiateViewController(identifier: "creditStoryboard") as? CreditViewController else {return}
        
        present(creditVC, animated: true, completion: nil)
    }
    
    
    func presentFullScreenQrCodeVC(){
        guard let fullScreenQrVC = storyboard?.instantiateViewController(identifier: "fullScreenQrCodeStoryboard") as? FullScreenQrCodeViewController else {return}
        
        fullScreenQrVC.modalPresentationStyle = .fullScreen
        fullScreenQrVC.backgroundColor = qrCodeBackgroundColor
        fullScreenQrVC.foregroundColor = qrCodeForegroundColor
        fullScreenQrVC.qrCodeBorderStyle = qrCodeBorderImageView.image
        fullScreenQrVC.qrCodeImage = resultQrCodeImageView.image
        
        present(fullScreenQrVC, animated: true, completion: nil)
    }
    
    
    func addOneSec(){
        UserDefaults.standard.setValue(Date(), forKey: "")
    }
    
    
    @objc
    func qrCodeTap(_ sender: UITapGestureRecognizer){
        presentFullScreenQrCodeVC()
    }
}


// MARK: - Extensions

// Color picer view delegate
extension ViewController: UIColorPickerViewControllerDelegate{
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        
        print("color changed")
        if isBgColorSelecting {
            qrCodeBoardView.backgroundColor = selectedColor
            qrCodeBackgroundColor = selectedColor
        }else{
            qrCodeForegroundColor = selectedColor
        }
    
        // notify to textfield to generate new qrCode
        sourceStringTextfield.sendActions(for: .valueChanged)
        
    }
}

// color selector collectionview delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, CustomColorCollectionViewDelegate, CustomBorderCollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case backgrondColorCollectionView:
            
            return backgroundColorArr.count
        case foregroundColorCollectionView:
            
            return foregroundColorArr.count
        case borderStyleCollectionView:
            
            return borderStyleArr.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case backgrondColorCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundColorCell", for: indexPath) as! ColorCell
            
            setRadius(view: cell.colorButton, radius: cell.colorButton.frame.width/2)
            setShadow(view: cell.colorButton, opacity: 0.5, shadowRadius: 4)
            cell.colorButton.layer.borderWidth = 1
            cell.colorButton.layer.borderColor = UIColor.white.cgColor
            cell.colorButton.backgroundColor = backgroundColorArr[indexPath.row]
            
            cell.configure(collectionView, cellForItemAt: indexPath)
            cell.delegate = self
            
            return cell
        case foregroundColorCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ForegroundColorCell", for: indexPath) as! ColorCell
            
            setRadius(view: cell.colorButton, radius: cell.colorButton.frame.width/2)
            setShadow(view: cell.colorButton, opacity: 0.5, shadowRadius: 4)
            cell.colorButton.layer.borderWidth = 1
            cell.colorButton.layer.borderColor = UIColor.white.cgColor
            cell.colorButton.backgroundColor = foregroundColorArr[indexPath.row]
            
            cell.configure(collectionView, cellForItemAt: indexPath)
            cell.delegate = self
            
            return cell
        case borderStyleCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BorderStyleCell", for: indexPath) as! BorderStyleCell
            
            cell.borderStyleButton.setImage(borderStyleArr[indexPath.row], for: .normal)
            
            cell.configure(collectionView, cellForItemAt: indexPath)
            cell.delegate = self
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func didTapColorButton(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) {
        switch collectionView {
        case backgrondColorCollectionView:
            qrCodeBoardView.backgroundColor = backgroundColorArr[indexPath.row]
            qrCodeBackgroundColor = backgroundColorArr[indexPath.row]
            break
        case foregroundColorCollectionView:
            qrCodeForegroundColor = foregroundColorArr[indexPath.row]
            qrCodeBorderImageView.tintColor = foregroundColorArr[indexPath.row]
            break
        default:
            return
        }
        
        // notify to textfield to generate new qrCode
        sourceStringTextfield.sendActions(for: .valueChanged)
    }
    
    func didTapBorderStyle(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) {
        qrCodeBorderImageView.image = borderStyleArr[indexPath.row]
        
        // notify to textfield to generate new qrCode
        sourceStringTextfield.sendActions(for: .valueChanged)
    }
}
