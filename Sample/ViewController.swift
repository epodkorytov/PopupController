//
//  ViewController.swift
//  Sample
//


import UIKit
import LocalAuthentication
import Indicator
import PopUpController
import Extensions

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    
    @IBAction func btnActivityIndicatorTap(_ sender: UIButton) {
        
        func progressIndicator(_ currentProgress: CGFloat) {
            if currentProgress <= 1.0 {
                PopUpController.indicator(setProgress: currentProgress)
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    progressIndicator(currentProgress + 0.05)
                }
            }
        }
        
        switch sender.tag {
        case 1:
            PopUpController.presentIndicator(type: .circular(type: .infinit), cancelOnTap: true)
        case 2:
            PopUpController.presentIndicator(type: .circular(type: .progress), cancelOnTap: true)
            progressIndicator(0.0)
        case 3:
            let style = IndicatorStyleDefault(strokeColors: [#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)],
                                              size: CGSize(width: 50.0, height: 50.0),
                                              strokeWidth: 3.0,
                                              colorAnimationDuration: 10.0)
            PopUpController.presentIndicator(type: .circularExtended(type: .infinit, style: style), cancelOnTap: true)
        default:
            PopUpController.presentIndicator(cancelOnTap: true)
        }
    }
    
    @IBAction func btnAlertViewTap(_ sender: UIButton) {
        var style = AlertViewStyleDefault()
            style.cornerRadius = 10.0
        
        PopUpController.sharedInstance.alertViewStyle = style
        
        let btnOK = AlertViewButton(title: "OK", answerType: .accept, isDefault: true)
        let btnCancel = AlertViewButton(title: "Cancel", answerType: .cancel, isDefault: false)
        
        PopUpController.sharedInstance.presentAlertView(image: UIImage(named: "ic_virgo"),
                                                        title: "Title titlt titlt longtitle Title titlt titlt longtitle",
                                                        text: "PopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()\nPopUpController.sharedInstance.alertViewStyle = AlertViewStyleDefault()",
                                                        buttons: [btnOK, btnCancel]) { answer in
                                                            print(answer)
        }
    }
    
    @IBAction func btnPinViewTap() {
//        PopUpController.sharedInstance.presentPinView(touchIDType: .visible) { (answer) in
        /*
        PopUpController.sharedInstance.presentInputPinView { answer in
            switch answer {
                case .passcode(let passcode):
                print("Passcode : \(passcode)")
                default:
                    break
            }
        }
        */
        let pin = "1111"
        
        PopUpController.sharedInstance.presentPinView(touchIDType: TouchIDType.immediate) { answer in
            switch answer {
                case .passcode(let passcode):
                    print("Passcode : \(passcode)")
                    PopUpController.sharedInstance.pinView.isPasscodeValid?(passcode == pin)
                    if passcode == pin {
                        PopUpController.dismiss {}
                    }
                    break
                
                case .touchID:
                    print("show touchID!")
                    
                    break
            default:
                break
            }
            
        }
        
    }
    typealias T = URL//UIColor //ExpressibleByNilLiteral
    let item0 = DataSourceItem<T>(id: 0, title: "\u{2648}", selected: false)
    let item1 = DataSourceItem<T>(id: 1, title: "Title1", selected: true)
    let item2 = DataSourceItem<T>(id: 2, title: "Title2", selected: false)
    let item3 = DataSourceItem<T>(id: 3, title: "Title3", selected: false)
    
    
    public struct SelectorViewTopBarStyleDefault: SelectorViewTopBarStyle {
        public var popupBackgroundColor = UIColor.white
        public var cornerRadius: CGFloat = 5.0
        public var backgroundColor: UIColor = "#FA6821".ifColor ?? .orange
        
        public var titleFont: UIFont  = UIFont.boldSystemFont(ofSize: 16)
        public var titleColor: UIColor = .white
        
        public var titleButtonFont: UIFont  = UIFont.systemFont(ofSize: 14)
        public var titleButtonColor: UIColor = .white
        public var titleButton: String = "Done"
        public var topBarHieght: CGFloat = 44.0
        
        public init() { }
    }
    
    public struct SelectorCellStyleDefault: SelectorCellStyle {
        public var tintColor: UIColor = .orange
        
        public var titleFont: UIFont  = UIFont.systemFont(ofSize: 16)
        public var titleColor: UIColor = "4A4A4A".ifColor ?? .blue
        
        public var imageNornal: UIImage? = nil
        public var imageSelected: UIImage? = nil
        public var placeholder: UIImage? = nil
    }
    
    public struct AppSelectorViewStyleDefault: SelectorViewStyle {
        public var cellStyle: SelectorCellStyle = SelectorCellStyleDefault()
        public var backgroundColor = UIColor(white: 0.1, alpha: 0.3)
        public var popupBackgroundColor = UIColor.white
        public var cornerRadius: CGFloat = 5.0
        
        public var width: CGFloat = 300.0
        public var minHieght: CGFloat = 2*44.0
        public var maxHieght: CGFloat = 380.0
        
        public var topBarStyle: SelectorViewTopBarStyle = SelectorViewTopBarStyleDefault()
        
        public var separatorStyle: UITableViewCell.SeparatorStyle = .none
        public var separatorColor: UIColor = "4A4A4A".ifColor ?? .blue
        public var separatorInset: UIEdgeInsets = UIEdgeInsets.zero
        
    }
    
    @IBAction func btnSelectorTap() {
        
        item0.value = URL(string: "http://static.sugardaddyme.info/img/zodiacs/aquarius.png")//.red
        item1.value = URL(string: "http://static.sugardaddyme.info/img/zodiacs/aquarius.png")//.white
        item2.value = URL(string: "http://static.sugardaddyme.info/img/zodiacs/aquarius.png")//.yellow
        item3.value = URL(string: "http://static.sugardaddyme.info/img/zodiacs/aquarius.png")//.black
        
        let items = [item0,item1,item2,item3]
        let dataSource: DataSource<DataSourceBaseItem> = DataSource(items: items)
        
        //presentPicker
//        PopUpController.sharedInstance.presentPicker(title: "Select Item", dataSource: dataSource) { answer, object in
//            dump(object)
//        }
        //presentSelector
        let popup = PopUpController.sharedInstance
        
        popup.selectorViewStyle = AppSelectorViewStyleDefault()
        popup.presentSelector(title: "Select Item",
                                                       type: .multiple,
                                                       dataSource: dataSource) { (answer, obj) in
             print(obj ?? "Empty")
                                                        
        }
 
    }
    
    
    @IBAction func btnAuthTap(_ sender: UIButton) {
        var type: AlertViewType = .signIn
        var login: String? = nil
        if sender.tag == 1 {
            type = .signUp
        } else if sender.tag == 2 {
            type = .recovery
        } else if sender.tag == 3 {
            type = .smsCode
        } else if sender.tag == 4 {
            type = .newPassword
            login = "example@mail.ru"
        }
        PopUpController.sharedInstance.presentAuthView(backgroundImage: #imageLiteral(resourceName: "bg"),
                                                       logoImage: #imageLiteral(resourceName: "logo"),
                                                       type: type,
                                                       login: login)
        { (answer) in
            print(answer)
            let authView = PopUpController.sharedInstance.authView
            switch answer {
            case .signUp(let login, _):
                let validate = PopUpController.sharedInstance.authView.validateLogin(for: login)
                if validate == .unknown {
                    // view is checking its data before send to controller, this code placed here just for example
                    authView?.wrongLogin(message: "Введите email или номер телефона")
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
                        if validate == .email {
                            authView?.showMessage("На указанный email мы отправили ссылку для активации аккаунта и дальнейшие инструкции. Проверьте пожалуйста Ваш email.")
                        } else if validate == .phone {
                            authView?.showCodeInput()
                        } else {
                            authView?.wrongLogin(message: "Введите email или номер телефона")
                        }
                    })
                }
            case .smsCode(let code):
                if code == "1111" {
                    PopUpController.dismiss {}
                } else {
                    authView?.wrongCode(message: "Вы ввели неправильный код")
                }
            case .checkPassword(let password, _):
                if password == "1111" {
                    authView?.showNewPassScene()
                } else {
                    authView?.wrongOldPassword(message: "Вы ввели неверный пароль")
                }
            default:
                PopUpController.dismiss {}
            }
        }
    }
    
    @IBAction func btnTimePickerTap() {
        PopUpController.sharedInstance.presentTimePicker(title: "Time") { (answer, obj) in
            dump(obj)
        }
    }
    @IBAction func btnBDayPickerTap() {
        PopUpController.sharedInstance.presentDatePicker(title: "Date") { (answer, obj) in
            dump(obj)
        }
        
        
    }
    
}

