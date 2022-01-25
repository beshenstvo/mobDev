//
//  CodeEditViewController.swift
//

import UIKit

protocol CodeView: AnyObject {
    func setupView()
    func layoutView()
    func willAppear()
    func willDisappear()
    func changeField()
    func startActivityIndicator()
    func stopActivityIndicator()
    func startAlert()
    func sendSMSClicked()
    
}

class CodeEditViewController: UIViewController {
    
    var codeModel: Code
    var continueButtonBottomConstraint: NSLayoutConstraint!
    private let presenter: CodeProtocol
    init(codeModel: Code, presenter: CodeProtocol) {
        self.codeModel = codeModel
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Код из смс"
        label.font = UIFont.systemFont(ofSize: 23, weight: .light)
        label.textColor = .label
        return label
    }()

    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        label.textColor = .label
        return label
    }()
    
    let codeField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "0000"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 12.0
        
        textField.keyboardType = .numberPad
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        
        return textField
    }()

    let continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .lightGray
        button.setBackgroundImage(UIImage(color: .blue), for: .highlighted)
        button.clipsToBounds = true
        button.layer.cornerRadius = 11.72
        button.isEnabled = false
        return button
    }()
    
    let alertLabel: UILabel = {
        let label = UILabel()
        label.text = "Это неправильный код"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        return label
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappearEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppearEvent()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoadEvent()
    }
    
}

extension CodeEditViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        if text.count == codeModel.codePattern.count {
            self.enableCodeButton(true)
            self.codeModel.normalCodeString = text
        } else {
            self.enableCodeButton(false)
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        
        if text.count == codeModel.codePattern.count {
            self.enableCodeButton(true)
            self.codeModel.normalCodeString = text
        } else {
            self.enableCodeButton(false)
        }
        return true
    }
    
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newLength = text.count + string.count - range.length
        textField.text = text.formattedText(format: codeModel.codePattern, appendChapter: "#")
        return newLength <= codeModel.codePattern.count
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.black.cgColor
        textField.text = ""
        alertLabel.isHidden = true
        enableCodeButton(false)
    }
}

extension CodeEditViewController {
    
//    func sendSMSClicked() {
//        hideKB()
//        navigationController?.popToRootViewController(animated: true)
//    }

    fileprivate func enableCodeButton(_ enabled: Bool) {
        continueButton.isEnabled = enabled
        continueButton.backgroundColor = (enabled) ? .systemBlue : .lightGray
    }
    
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.continueButtonBottomConstraint.constant = -(keyboardFrame.cgRectValue.height + 10)
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.continueButtonBottomConstraint.constant = -20
                self?.view.layoutIfNeeded()
            }
        }
    }
}

extension CodeEditViewController: CodeView {
    
    func setupView() {
   
        view.backgroundColor = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        phoneLabel.text = "Отправлен на \(codeModel.phoneString)"
        
        navigationItem.title = "Код"
        
        view.addSubview(titleLabel)
        view.addSubview(phoneLabel)
        view.addSubview(codeField)
        view.addSubview(continueButton)
        view.addSubview(alertLabel)
        view.addSubview(activityIndicator)
        
        continueButtonBottomConstraint = continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        codeField.delegate = self
        
        continueButton.addTarget(self, action: #selector(CodePresenter.checkCode), for: .touchUpInside)
    }
    
    func layoutView() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            codeField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            codeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            codeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            codeField.heightAnchor.constraint(equalToConstant: 42),
                        
            continueButtonBottomConstraint,
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            continueButton.heightAnchor.constraint(equalToConstant: 44),
            
            alertLabel.topAnchor.constraint(equalTo: codeField.bottomAnchor, constant: 8),
            alertLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func willAppear() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func willDisappear() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    func startActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func changeField() {
        codeField.resignFirstResponder()
    }
    
    func startAlert() {
        alertLabel.isHidden = false
    }
    
    func sendSMSClicked() {
        view.endEditing(true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}
