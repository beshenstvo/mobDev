//
//  PhoneEditViewController.swift
//

import UIKit

protocol PhoneView: AnyObject {
    func buildView()
    func buildConstraints()
    func willAppear()
    func willDisappear()
}

final class PhoneEditViewController: UIViewController {
    
    // MARK: - Properties
    var normalPhoneString = ""
    let phonePattern = "+# (###) ###-##-##"
    var getCodeBottomConstraint: NSLayoutConstraint!
    let presenter: PhonePresenterProtocol
    
    init(presenter: PhonePresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - UI elements
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    let phoneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Номер телефона"
        label.font = UIFont.systemFont(ofSize: 23, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    let phoneField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clipsToBounds = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 12.0
        
        textField.text = "+7"
        textField.keyboardType = .numberPad
        
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        
        return textField
    }()

    let noticeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Пользовательское соглашение"
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = .label
        label.isUserInteractionEnabled = true
        return label
    }()

    let getCodeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Получить код", for: .normal)
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 18, weight: .medium)
        button.backgroundColor = .lightGray
        button.setBackgroundImage(UIImage(color: .blue), for: .highlighted)
        button.clipsToBounds = true
        button.layer.cornerRadius = 11.72
        button.isEnabled = false
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.willDisappear()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.willAppear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.viewDidLoadEvent()
    }
    
}

extension PhoneEditViewController: UITextFieldDelegate {
    
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }

        if text.count == phonePattern.count {
            enableCodeButton(true)
            normalPhoneString = text
        } else {
            enableCodeButton(false)
        }
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let newLength = text.count + string.count - range.length
        textField.text = text.formattedText(format: phonePattern, appendChapter: "#")
        return newLength <= phonePattern.count
    }
}

extension PhoneEditViewController {
    
    func enableCodeButton(_ enabled: Bool) {
        getCodeButton.isEnabled = enabled
        getCodeButton.backgroundColor = enabled ? .systemBlue : .lightGray
    }
    
    @objc func getCodeClicked() {
        hideKB()
        
//        let phoneNumberWithOutPattern = normalPhoneString.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        activityIndicator.startAnimating()
        
        presenter.didCodeClicked()
    }
    
    @objc func openAgreementVC() {
        presenter.didAgreementClicked()
    }
    
    @objc func hideKB() {
        view.endEditing(true)
    }
    
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.getCodeBottomConstraint.constant = -(keyboardFrame.cgRectValue.height + 10)
            self?.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.getCodeBottomConstraint.constant = -20
                self?.view.layoutIfNeeded()
            }
        }
    }
}

extension PhoneEditViewController: PhoneView {
    func buildView() {
        view.backgroundColor = .systemBackground
        
        phoneField.delegate = self
        navigationItem.title = "Вход"
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKB)))
        noticeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openAgreementVC)))
        getCodeButton.addTarget(self, action: #selector(getCodeClicked), for: .touchUpInside)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(phoneLabel)
        view.addSubview(phoneField)
        view.addSubview(noticeLabel)
        view.addSubview(getCodeButton)
        view.addSubview(activityIndicator)
    }
    
    func buildConstraints() {
        
        getCodeBottomConstraint = getCodeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        NSLayoutConstraint.activate([
            phoneLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            phoneLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneField.topAnchor.constraint(equalTo: phoneLabel.bottomAnchor, constant: 8),
            phoneField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            phoneField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            phoneField.heightAnchor.constraint(equalToConstant: 42),
            
            noticeLabel.bottomAnchor.constraint(equalTo: getCodeButton.topAnchor, constant: -8),
            noticeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            noticeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            getCodeBottomConstraint,
            getCodeButton.heightAnchor.constraint(equalToConstant: 44),
            getCodeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            getCodeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
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
}
