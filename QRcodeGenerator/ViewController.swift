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


class ViewController: UIViewController, UITextFieldDelegate {
    
    var backgroundColorArr = Array<UIColor>()
    var foregroundColorArr = Array<UIColor>()
    var borderStyleArr = Array<UIImage>()
    
    @IBOutlet weak var backgrondColorCollectionView: UICollectionView!
    @IBOutlet weak var foregroundColorCollectionView: UICollectionView!
    @IBOutlet weak var borderStyleCollectionView: UICollectionView!
    
    
    @IBOutlet weak var appbarView: UIView!
    @IBOutlet weak var TFstring: UITextField!
    @IBOutlet weak var BTNgenerate: UIButton!
    @IBOutlet weak var resultQRcodeImage: UIImageView!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var QRcodeBoard: UIView!
    
    @IBOutlet weak var exportBoard: UIView!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var backgroundColorBoard: UIView!
    @IBOutlet weak var foregroundColorBoard: UIView!
    
    @IBOutlet weak var bgColorPalleteButton: UIButton!
    @IBOutlet weak var fgColorPalleteButton: UIButton!
    
    
    @IBOutlet weak var border: UIImageView!
    @IBOutlet weak var borderStyleBoard: UIView!
    
    private var qrCodeSourceString = ""
    private var qrCodeBackgroundColor = UIColor.white
    private var qrCodeForegroundColor = UIColor.black
    
    
    // Background Color Picker
    private var selectedColor = UIColor.systemTeal
    private var colorPicker = UIColorPickerViewController()
    
    // Foreground Color Picker
    private var isBgColorSelecting = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButton()
        
        initData()
        initDesign()
        initInstance()
    }
    
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
    
    func initDesign(){
        // Appbar
        setRadius(view: appbarView, radius: 35)
        appbarView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        
        // Source data string TextField
        TFstring.backgroundColor = UIColor.white
        setRadius(view: TFstring, radius: 20)
        // set padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.TFstring.frame.height))
        TFstring.leftView = paddingView
        TFstring.rightView = paddingView
        TFstring.leftViewMode = .always
        
        
        // result Image
        setRadius(view: resultQRcodeImage, radius: 7)
        
        // Generate Button
        setRadius(view: BTNgenerate, radius: 25)
        setShadow(view: BTNgenerate, opacity: 0.5, shadowRadius: 10)
        
        
        // QRcode Board
        setRadius(view: QRcodeBoard, radius: 15)
        setShadow(view: QRcodeBoard, opacity: 0.2, shadowRadius: 15)
        
        // Option Board
        setRadius(view: exportBoard, radius: 15)
        setShadow(view: exportBoard, opacity: 0.2, shadowRadius: 15)
        
        // BakcgroundColor Board
        setRadius(view: backgroundColorBoard, radius: 15)
        setShadow(view: backgroundColorBoard, opacity: 0.2, shadowRadius: 15)
        
        // ForegroundColor Board
        setRadius(view: foregroundColorBoard, radius: 15)
        setShadow(view: foregroundColorBoard, opacity: 0.2, shadowRadius: 15)
        
        //BorderStyle Board
        setRadius(view: borderStyleBoard, radius: 15)
        setShadow(view: borderStyleBoard, opacity: 0.2, shadowRadius: 15)
        
        // Background Color picker Button
        setShadow(view: bgColorPalleteButton, opacity: 0.8, shadowRadius: 2)
        
        // Foreground Color picker Button
        setShadow(view: fgColorPalleteButton, opacity: 0.8, shadowRadius: 2)
    }
    
    func initInstance(){
        TFstring.delegate = self
        colorPicker.delegate = self
        
        backgrondColorCollectionView.delegate = self
        backgrondColorCollectionView.dataSource = self
        
        foregroundColorCollectionView.delegate = self
        foregroundColorCollectionView.dataSource = self
        
        borderStyleCollectionView.delegate = self
        borderStyleCollectionView.dataSource = self
    }
    
    
    
    
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
    func generateQRCode(){
        border.image = border.image?.withRenderingMode(.alwaysTemplate)
        border.tintColor = qrCodeForegroundColor
        
        let sourceString = qrCodeSourceString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let qrCodeGenerator = QRCodeGenerator()
        qrCodeGenerator.correctionLevel = .H
        
        // set color
        qrCodeGenerator.backgroundColor = qrCodeBackgroundColor
        qrCodeGenerator.foregroundColor = qrCodeForegroundColor
        
        // generate QRcode
        let mQrCode = qrCodeGenerator.createImage(value: sourceString, size: CGSize(width: resultQRcodeImage.bounds.width, height: resultQRcodeImage.bounds.height), encoding: String.Encoding.utf8)
        

        resultQRcodeImage.image = mQrCode
    }
    func showColorPicker(){
        if #available(iOS 14.0, *){
            colorPicker.supportsAlpha = true
            
            colorPicker.selectedColor = selectedColor
            present(colorPicker, animated: true)
        }else{
            self.view.makeToast("Color pallete is supported only on iOS 14.0 and later.")
        }
        
    }
    func setupBarButton(){
        _ = UIAction(title: "Pick Color"){ _ in
            self.showColorPicker()
        }
    }
    
    // Export Action
    func saveQrCode(){
        // request Album Permission
        if PHPhotoLibrary.authorizationStatus() != .authorized{
            PHPhotoLibrary.requestAuthorization { (status) in
               // system permission request dialog
                if status == .authorized{
                    return
                }
            }
            
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Access album permission", message: "To save QrCode, you need to allow permission for access album.", preferredStyle: .alert)
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
        }else{
            // Save Alert
            DispatchQueue.main.async {
                let dialog = UIAlertController(title: "Save", message: "Save the QrCode to the album?", preferredStyle: .alert)
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
                self.present(dialog, animated: true, completion: nil)
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
        UIGraphicsBeginImageContextWithOptions(QRcodeBoard.frame.size, false, 0.0)
        QRcodeBoard.layer.render(in: UIGraphicsGetCurrentContext()!)
        let qrCode = UIGraphicsGetImageFromCurrentImageContext()
        
        return qrCode!
    }
    
    
    
    // Generate Button Action
    @IBAction func generateQRcodeAction(_ sender: Any) {
        qrCodeSourceString = TFstring.text ?? ""
        generateQRCode()
    }
    
    // Export Actions
    @IBAction func saveButtonAction(_ sender: Any) {
        saveQrCode()
    }
    @IBAction func shareButtonAction(_ sender: Any) {
        shareQrCode()
    }
    
    // Background Color Board
    @IBAction func bgColorPickerAction(_ sender: Any) {
        isBgColorSelecting = true
        showColorPicker()
    }
    
    // Foreground Color Board
    @IBAction func fgColorPickerAction(_ sender: Any) {
        isBgColorSelecting = false
        showColorPicker()
    }
    
    
    // Border Style Board
    @IBAction func clearBorderStyleButtonAction(_ sender: Any) {
        border.isHidden = true
    }
    
    // TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}


extension ViewController: UIColorPickerViewControllerDelegate{
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
        
        print("color changed")
        if isBgColorSelecting {
            QRcodeBoard.backgroundColor = selectedColor
            qrCodeBackgroundColor = selectedColor
        }else{
            qrCodeForegroundColor = selectedColor
        }
        generateQRCode()
        
    }
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        print("did dismiss function")
    }
}


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
            QRcodeBoard.backgroundColor = backgroundColorArr[indexPath.row]
            qrCodeBackgroundColor = backgroundColorArr[indexPath.row]
            
            generateQRCode()
            
            break;
        case foregroundColorCollectionView:
            qrCodeForegroundColor = foregroundColorArr[indexPath.row]
            border.tintColor = foregroundColorArr[indexPath.row]
            
            generateQRCode()
            
            break;
        default:
            break;
        }
    }
    
    func didTapBorderStyle(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) {
        border.isHidden = false
        border.image = borderStyleArr[indexPath.row]
        
        generateQRCode()
    }
}
