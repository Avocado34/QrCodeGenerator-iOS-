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
import GoogleMobileAds



class ViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate {
    
    private let ADMOB_UNIT_ID = "ca-app-pub-3998172297943713/4841787663"

    @IBOutlet weak var appbar: UIView!
    @IBOutlet weak var appbarTitle: UILabel!
    @IBOutlet weak var TFstring: UITextField!
    @IBOutlet weak var BTNgenerate: UIButton!
    @IBOutlet weak var resultQRcodeImage: UIImageView!
    @IBOutlet weak var LBwarning: UILabel!
    
    @IBOutlet weak var QRcodeBoard: UIView!
    @IBOutlet weak var exportBoard: UIView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var backgroundColorBoard: UIView!
    @IBOutlet weak var foregroundColorBoard: UIView!
    
    @IBOutlet weak var bgColorPalleteButton: UIButton!
    @IBOutlet weak var bgColorSelectionScrollView: UIScrollView!
    @IBOutlet weak var bgColorSelectionButton1: UIButton!
    @IBOutlet weak var bgColorSelectionButton2: UIButton!
    @IBOutlet weak var bgColorSelectionButton3: UIButton!
    @IBOutlet weak var bgColorSelectionButton4: UIButton!
    @IBOutlet weak var bgColorSelectionButton5: UIButton!
    @IBOutlet weak var bgColorSelectionButton6: UIButton!
    
    @IBOutlet weak var fgColorPalleteButton: UIButton!
    @IBOutlet weak var fgColorSelectionScrollView: UIScrollView!
    @IBOutlet weak var fgColorSelectionButton1: UIButton!
    @IBOutlet weak var fgColorSelectionButton2: UIButton!
    @IBOutlet weak var fgColorSelectionButton3: UIButton!
    @IBOutlet weak var fgColorSelectionButton4: UIButton!
    @IBOutlet weak var fgColorSelectionButton5: UIButton!
    @IBOutlet weak var fgColorSelectionButton6: UIButton!
    
    
    @IBOutlet weak var borderStyleScrollView: UIScrollView!
    @IBOutlet weak var border: UIImageView!
    @IBOutlet weak var borderStyleBoard: UIView!
    
    //constraints
    @IBOutlet weak var appbarTitleTopMargin: NSLayoutConstraint!
    @IBOutlet weak var appbarMenuButtonTopMargin: NSLayoutConstraint!
    @IBOutlet weak var appbarHeight: NSLayoutConstraint!
    @IBOutlet weak var qrCodeBoardHeight: NSLayoutConstraint!
    @IBOutlet weak var qrCodeBoardWidth: NSLayoutConstraint!
    @IBOutlet weak var menuButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var menuButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var stringTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var qrCodeMarginLeft: NSLayoutConstraint!
    @IBOutlet weak var qrCodeMarginBottom: NSLayoutConstraint!
    @IBOutlet weak var qrCodeMarginRight: NSLayoutConstraint!
    @IBOutlet weak var qrCodeMarginTop: NSLayoutConstraint!
    // END
    
    
    private var qrCodeSourceString = ""
    private var qrCodeBackgroundColor = UIColor.white
    private var qrCodeForegroundColor = UIColor.black
    
    private var interstitial: GADInterstitial!
    
    // Background Color Picker
    private var selectedColor = UIColor.systemTeal
    private var colorPicker = UIColorPickerViewController()
    
    // Foreground Color Picker
    private var isBgColorSelecting = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resizeView()
        
        colorPicker.delegate = self
        setupBarButton()
        
        setAppbar()
        setStringTextField()
        setResultImage()
        setGenerateButton()
        setBoards()
        setBackgroundColorButtons()
        setForegroundColorButtons()
        
        setGoogleAdMob()
    }
    
    func resizeView(){
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                case 1136:
                    print("iPhone 5 or 5S or 5C")

                    appbarTitleTopMargin.constant = 35
                    appbarHeight.constant = 190
                    appbarMenuButtonTopMargin.constant = 45
                    qrCodeBoardHeight.constant = 250
                    qrCodeBoardWidth.constant = 250
                    appbarTitle.font = appbarTitle.font.withSize(25)
                    menuButtonWidth.constant = 19
                    menuButtonHeight.constant = 19
                    stringTextFieldHeight.constant = 50
                    TFstring.font = TFstring.font?.withSize(14)
                    qrCodeMarginTop.constant = 80
                    qrCodeMarginBottom.constant = 80
                    qrCodeMarginRight.constant = 80
                    qrCodeMarginLeft.constant = 80
                    
                case 1334:
                    print("iPhone 6/6S/7/8")
                    
                    appbarTitleTopMargin.constant = 40
                    appbarHeight.constant = 215
                    appbarMenuButtonTopMargin.constant = 50

                case 1920, 2208:
                    print("iPhone 6+/6S+/7+/8+")
                case 2436:
                    print("iPhone X/XS/11 Pro")
                case 2688:
                    print("iPhone XS Max/11 Pro Max")
                case 1792:
                    print("iPhone XR/ 11 ")
                default:
                    print("Unknown")
                }
            }
    }
    
    func setAppbar(){
        setRadius(view: appbar, radius: 30)
        setShadow(view: appbar, opacity: 0.9, shadowRadius: 10)
        appbar.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
    }
    func setStringTextField(){
        TFstring.delegate = self
        TFstring.backgroundColor = UIColor.white
        setRadius(view: TFstring, radius: 20)
        
        // set padding
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.TFstring.frame.height))
        TFstring.leftView = paddingView
        TFstring.rightView = paddingView
        TFstring.leftViewMode = .always
    }
    func setResultImage(){
        setRadius(view: resultQRcodeImage, radius: 7)
    }
    func setGenerateButton(){
        setRadius(view: BTNgenerate, radius: 25)
        setShadow(view: BTNgenerate, opacity: 0.5, shadowRadius: 10)
    }
    func setBoards(){
        // QRcode Board
        setRadius(view: QRcodeBoard, radius: 15)
        setShadow(view: QRcodeBoard, opacity: 0.2, shadowRadius: 15)
        
        // Option Board
        setRadius(view: exportBoard, radius: 15)
        setShadow(view: exportBoard, opacity: 0.2, shadowRadius: 15)
        
        // BakcgroundColor Board
        setRadius(view: bgColorSelectionScrollView, radius: 15)
        setRadius(view: backgroundColorBoard, radius: 15)
        setShadow(view: backgroundColorBoard, opacity: 0.2, shadowRadius: 15)
        
        // ForegroundColor Board
        setRadius(view: fgColorSelectionScrollView, radius: 15)
        setRadius(view: foregroundColorBoard, radius: 15)
        setShadow(view: foregroundColorBoard, opacity: 0.2, shadowRadius: 15)
        
        //BorderStyle Board
        setRadius(view: borderStyleScrollView, radius: 15)
        setRadius(view: borderStyleBoard, radius: 15)
        setShadow(view: borderStyleBoard, opacity: 0.2, shadowRadius: 15)
    }
    func setBackgroundColorButtons(){
        setShadow(view: bgColorPalleteButton, opacity: 0.8, shadowRadius: 2)
        setShadow(view: bgColorSelectionButton1, opacity: 0.8, shadowRadius: 2)
        setShadow(view: bgColorSelectionButton2, opacity: 0.8, shadowRadius: 2)
        setShadow(view: bgColorSelectionButton3, opacity: 0.8, shadowRadius: 2)
        setShadow(view: bgColorSelectionButton4, opacity: 0.8, shadowRadius: 2)
        setShadow(view: bgColorSelectionButton5, opacity: 0.8, shadowRadius: 2)
        setShadow(view: bgColorSelectionButton6, opacity: 0.8, shadowRadius: 2)
        
        setRadius(view: bgColorSelectionButton1, radius: 0.5 * bgColorSelectionButton1.bounds.size.width)
        setRadius(view: bgColorSelectionButton2, radius: 0.5 * bgColorSelectionButton2.bounds.size.width)
        setRadius(view: bgColorSelectionButton3, radius: 0.5 * bgColorSelectionButton3.bounds.size.width)
        setRadius(view: bgColorSelectionButton4, radius: 0.5 * bgColorSelectionButton4.bounds.size.width)
        setRadius(view: bgColorSelectionButton5, radius: 0.5 * bgColorSelectionButton5.bounds.size.width)
        setRadius(view: bgColorSelectionButton6, radius: 0.5 * bgColorSelectionButton6.bounds.size.width)
        
        setStroke(view: bgColorSelectionButton1, width: 2)
        setStroke(view: bgColorSelectionButton2, width: 2)
        setStroke(view: bgColorSelectionButton3, width: 2)
        setStroke(view: bgColorSelectionButton4, width: 2)
        setStroke(view: bgColorSelectionButton5, width: 2)
        setStroke(view: bgColorSelectionButton6, width: 2)
    }
    func setForegroundColorButtons(){
        setShadow(view: fgColorPalleteButton, opacity: 0.8, shadowRadius: 2)
        setShadow(view: fgColorSelectionButton1, opacity: 0.8, shadowRadius: 2)
        setShadow(view: fgColorSelectionButton2, opacity: 0.8, shadowRadius: 2)
        setShadow(view: fgColorSelectionButton3, opacity: 0.8, shadowRadius: 2)
        setShadow(view: fgColorSelectionButton4, opacity: 0.8, shadowRadius: 2)
        setShadow(view: fgColorSelectionButton5, opacity: 0.8, shadowRadius: 2)
        setShadow(view: fgColorSelectionButton6, opacity: 0.8, shadowRadius: 2)
        
        setRadius(view: fgColorSelectionButton1, radius: 0.5 * fgColorSelectionButton1.bounds.size.width)
        setRadius(view: fgColorSelectionButton2, radius: 0.5 * fgColorSelectionButton2.bounds.size.width)
        setRadius(view: fgColorSelectionButton3, radius: 0.5 * fgColorSelectionButton3.bounds.size.width)
        setRadius(view: fgColorSelectionButton4, radius: 0.5 * fgColorSelectionButton4.bounds.size.width)
        setRadius(view: fgColorSelectionButton5, radius: 0.5 * fgColorSelectionButton5.bounds.size.width)
        setRadius(view: fgColorSelectionButton6, radius: 0.5 * fgColorSelectionButton6.bounds.size.width)
        
        setStroke(view: fgColorSelectionButton1, width: 2)
        setStroke(view: fgColorSelectionButton2, width: 2)
        setStroke(view: fgColorSelectionButton3, width: 2)
        setStroke(view: fgColorSelectionButton4, width: 2)
        setStroke(view: fgColorSelectionButton5, width: 2)
        setStroke(view: fgColorSelectionButton6, width: 2)
    }
    func setGoogleAdMob(){
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        interstitial = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
        let request = GADRequest()
        interstitial.load(request)
        interstitial.delegate = self
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
    func createAd() -> GADInterstitial{
        let inter = GADInterstitial(adUnitID: ADMOB_UNIT_ID)
        inter.load(GADRequest())
        
        return inter
    }
    func showAdMob(){
        if interstitial.isReady{
            interstitial.present(fromRootViewController: self)
            interstitial = createAd()
            interstitial.delegate = self
        }else{
            print("admob is preparing")
        }
    }
    
    
    
    // Generate Button Action
    @IBAction func generateQRcodeAction(_ sender: Any) {
        qrCodeSourceString = TFstring.text ?? ""
        generateQRCode()
        showAdMob()
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
    @IBAction func bgColorSelector1Action(_ sender: Any) {
        qrCodeBackgroundColor = UIColor(named: "BackgroundColorSelection1") ?? UIColor.white
        QRcodeBoard.layer.backgroundColor = UIColor(named: "BackgroundColorSelection1")?.cgColor
        generateQRCode()
    }
    @IBAction func bgColorSelector2Action(_ sender: Any) {
        qrCodeBackgroundColor = UIColor(named: "BackgroundColorSelection2") ?? UIColor.white
        QRcodeBoard.layer.backgroundColor = UIColor(named: "BackgroundColorSelection2")?.cgColor
        generateQRCode()
    }
    @IBAction func bgColorSelector3Action(_ sender: Any) {
        qrCodeBackgroundColor = UIColor(named: "BackgroundColorSelection3") ?? UIColor.white
        QRcodeBoard.layer.backgroundColor = UIColor(named: "BackgroundColorSelection3")?.cgColor
        generateQRCode()
    }
    @IBAction func bgColorSelector4Action(_ sender: Any) {
        qrCodeBackgroundColor = UIColor(named: "BackgroundColorSelection4") ?? UIColor.white
        QRcodeBoard.layer.backgroundColor = UIColor(named: "BackgroundColorSelection4")?.cgColor
        generateQRCode()
    }
    @IBAction func bgColorSelector5Action(_ sender: Any) {
        qrCodeBackgroundColor = UIColor(named: "BackgroundColorSelection5") ?? UIColor.white
        QRcodeBoard.layer.backgroundColor = UIColor(named: "BackgroundColorSelection5")?.cgColor
        generateQRCode()
    }
    @IBAction func bgColorSeledtor6Action(_ sender: Any) {
        qrCodeBackgroundColor = UIColor(named: "BackgroundColorSelection6") ?? UIColor.white
        QRcodeBoard.layer.backgroundColor = UIColor(named: "BackgroundColorSelection6")?.cgColor
        generateQRCode()
    }
    
    // Foreground Color Board
    @IBAction func fgColorPickerAction(_ sender: Any) {
        isBgColorSelecting = false
        showColorPicker()
    }
    @IBAction func fgColorSelector1Action(_ sender: Any) {
        qrCodeForegroundColor = UIColor(named: "BackgroundColorSelection1") ?? UIColor.white
        generateQRCode()
    }
    @IBAction func fgColorSelector2Action(_ sender: Any) {
        qrCodeForegroundColor = UIColor(named: "BackgroundColorSelection2") ?? UIColor.white
        generateQRCode()
    }
    @IBAction func fgColorSelector3Action(_ sender: Any) {
        qrCodeForegroundColor = UIColor(named: "BackgroundColorSelection3") ?? UIColor.white
        generateQRCode()
    }
    @IBAction func fgColorSelector4Action(_ sender: Any) {
        qrCodeForegroundColor = UIColor(named: "BackgroundColorSelection4") ?? UIColor.white
        generateQRCode()
    }
    @IBAction func fgColorSelector5Action(_ sender: Any) {
        qrCodeForegroundColor = UIColor(named: "BackgroundColorSelection5") ?? UIColor.white
        generateQRCode()
    }
    @IBAction func fgColorSelector6Action(_ sender: Any) {
        qrCodeForegroundColor = UIColor(named: "BackgroundColorSelection6") ?? UIColor.white
        generateQRCode()
    }
    
    
    // Border Style Board
    @IBAction func clearBorderStyleButtonAction(_ sender: Any) {
        border.isHidden = true
    }
    @IBAction func borderStyle1Action(_ sender: Any) {
        border.isHidden = false
        border.image = UIImage(named: "BorderStyle1")
        border.image = border.image?.withRenderingMode(.alwaysTemplate)
        border.tintColor = qrCodeForegroundColor
    }
    @IBAction func borderStyle2Action(_ sender: Any) {
        border.isHidden = false
        border.image = UIImage(named: "BorderStyle2")
        border.image = border.image?.withRenderingMode(.alwaysTemplate)
        border.tintColor = qrCodeForegroundColor
    }
    @IBAction func borderStyle3Action(_ sender: Any) {
        border.isHidden = false
        border.image = UIImage(named: "BorderStyle3")
        border.image = border.image?.withRenderingMode(.alwaysTemplate)
        border.tintColor = qrCodeForegroundColor
    }
    @IBAction func borderStyle4Action(_ sender: Any) {
        border.isHidden = false
        border.image = UIImage(named: "BorderStyle4")
        border.image = border.image?.withRenderingMode(.alwaysTemplate)
        border.tintColor = qrCodeForegroundColor
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
