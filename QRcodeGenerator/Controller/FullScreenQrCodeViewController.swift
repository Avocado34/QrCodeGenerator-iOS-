//
//  FullScreenQrCodeViewController.swift
//  QRcodeGenerator
//
//  Created by 이승기 on 2021/06/15.
//

import UIKit
import RxSwift
import RxCocoa


class FullScreenQrCodeViewController: UIViewController {

    // MARK: - Delcarations
    var disposeBag = DisposeBag()
    
    var toggleState = true
    
    var backgroundColor: UIColor? // passed data
    var foregroundColor: UIColor? // passed data
    var qrCodeBorderStyle: UIImage? // passed data
    var qrCodeImage: UIImage? // passed data
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var sliderContentView: UIView!
    @IBOutlet weak var scaleSlider: UISlider!
    @IBOutlet var baseView: UIView!
    @IBOutlet weak var qrCodeBorderImageView: UIImageView!
    @IBOutlet weak var qrCodeBorderWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrCodeImageView: UIImageView!
    

    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        initView()
        initInstance()
        initEventListener()
        
    }
    
    // MARK: - Overrides
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        fitQrCodeScale()
    }
    
    
    // MARK: - Initializations
    func initView(){
        // set qrcode background color
        if let backgroundColor = backgroundColor{
            baseView.backgroundColor = backgroundColor
        }else {
            dismiss(animated: true, completion: nil)
        }
        
        // set qrcode foreground color
        if let foregroundColor = foregroundColor{
            qrCodeImageView.tintColor = foregroundColor
        }else {
            dismiss(animated: true, completion: nil)
        }
        
        // set qrcode image
        if let qrCodeImage = qrCodeImage{
            qrCodeImageView.image = qrCodeImage
        }else {
            dismiss(animated: true, completion: nil)
        }
        
        // set qrcode border style
        if let borderStyle = qrCodeBorderStyle{
            qrCodeBorderImageView.image = borderStyle
            qrCodeBorderImageView.tintColor = foregroundColor
        }
        
        // dismiss button
        dismissButton.layer.cornerRadius = dismissButton.frame.height / 2
        dismissButton.layer.shadowColor = UIColor.gray.cgColor
        dismissButton.layer.shadowOffset = .zero
        dismissButton.layer.shadowRadius = 10
        dismissButton.layer.shadowOpacity = 0.3
        
        // slider view
        sliderContentView.layer.cornerRadius = sliderContentView.frame.height / 2
        sliderContentView.layer.shadowColor = UIColor.gray.cgColor
        sliderContentView.layer.shadowOffset = .zero
        sliderContentView.layer.shadowRadius = 10
        sliderContentView.layer.shadowOpacity = 0.3
        
        // scale slider
        scaleSlider.minimumValue = 0.5
        scaleSlider.maximumValue = 2
        scaleSlider.value = 1
        
        // qr code border imageview
        qrCodeBorderImageView.translatesAutoresizingMaskIntoConstraints = false
        fitQrCodeScale()
        
    }
    func initInstance(){
        
    }
    func initEventListener(){
        // dismiss button action
        dismissButton.rx.tap
            .bind{ [unowned self] in
                self.dismiss(animated: true, completion: nil)
            }.disposed(by: disposeBag)
        
        // base view tap action
        baseView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleButtons(_:))))
        
        // slider value change event
        scaleSlider.rx.value
            .bind{ [unowned self] in
                self.setScale(multiplier: CGFloat($0))
            }.disposed(by: disposeBag)
    }
    
    
    // MARK: - Methods
    func setScale(multiplier: CGFloat){
        
        UIView.animate(withDuration: 0) { [unowned self] in
            self.qrCodeImageView.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
            self.qrCodeBorderImageView.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        }
    }
    
    func fitQrCodeScale(){
        
        DispatchQueue.global(qos: .background).async{
            usleep(100000)
            
            DispatchQueue.main.async {
                if UIDevice.current.orientation.isLandscape{
                    self.qrCodeBorderWidthConstraint.constant = self.view.frame.height / 2
                }else{
                    self.qrCodeBorderWidthConstraint.constant = self.view.frame.width / 2
                }
            }
        }
    }
    
    
    @objc
    func toggleButtons(_ sender: UITapGestureRecognizer){
        if toggleState{ // true -> false
            toggleState = false
            
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.dismissButton.alpha = 0
                self.sliderContentView.alpha = 0
            }
        }else{ // false -> true
            toggleState = true
            
            UIView.animate(withDuration: 0.3) { [unowned self] in
                self.dismissButton.alpha = 1
                self.sliderContentView.alpha = 1
            }
        }
    }
}


// MARK: - Extensions
