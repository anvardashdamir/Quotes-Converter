//
//  ViewController.swift
//  Quotes Converter
//
//  Created by Enver Dashdemirov on 12.10.24.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var currencies: CurrencyList = []
    private var currienciesRate: CurrencyRate?
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UIColor.MyTheme.textColor
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let majorCurrencyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyTheme.viewColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let secondCurrencyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.MyTheme.viewColor
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.MyTheme.textColor
        label.text = "Quotes Converter"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    
    private let topLeftSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let topRightSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let bottomLeftSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let bottomRightSubView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let topRightCurrencyPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let bottomRightCurrencyPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter amount"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
    }()
    
    private let convertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Convert", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.MyTheme.buttonColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    private var selectedCUR: UILabel = {
        let label = UILabel()
        return label
    }()
    
    
    private var targetedCUR: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let reverseCurrencyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reverse", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.MyTheme.buttonReverseColour
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        return button
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        
        topRightCurrencyPicker.delegate = self
        topRightCurrencyPicker.dataSource = self
        bottomRightCurrencyPicker.delegate = self
        bottomRightCurrencyPicker.dataSource = self
        
        fetchCurrencyList() { list in
            if list == nil {
                print("Failed to load currencies")
            }
        }
    }
    
    
    func setupUI() {
        view.backgroundColor = UIColor.MyTheme.backroundColor
        view.addSubview(majorCurrencyView)
        view.addSubview(secondCurrencyView)
        view.addSubview(titleLabel)
        view.addSubview(convertButton)
        view.addSubview(reverseCurrencyButton)
        
        majorCurrencyView.addSubview(topStackView)
        secondCurrencyView.addSubview(bottomStackView)
        topLeftSubView.addSubview(amountTextField)
        bottomLeftSubView.addSubview(resultLabel)
        topStackView.addArrangedSubview(topLeftSubView)
        topStackView.addArrangedSubview(topRightSubView)
        bottomStackView.addArrangedSubview(bottomLeftSubView)
        bottomStackView.addArrangedSubview(bottomRightSubView)
        topRightSubView.addSubview(topRightCurrencyPicker)
        bottomRightSubView.addSubview(bottomRightCurrencyPicker)
        
        majorCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondCurrencyView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        topRightCurrencyPicker.translatesAutoresizingMaskIntoConstraints = false
        bottomRightCurrencyPicker.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        convertButton.translatesAutoresizingMaskIntoConstraints = false
        reverseCurrencyButton.translatesAutoresizingMaskIntoConstraints = false
        
        convertButton.addTarget(self, action: #selector(convertButtonPressed), for: .touchUpInside)
        reverseCurrencyButton.addTarget(self, action: #selector(reverseButtonPressed), for: .touchUpInside)
        
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            majorCurrencyView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            majorCurrencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            majorCurrencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            majorCurrencyView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            secondCurrencyView.topAnchor.constraint(equalTo: majorCurrencyView.bottomAnchor, constant: 4),
            secondCurrencyView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            secondCurrencyView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            secondCurrencyView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: majorCurrencyView.topAnchor, constant: 6),
            topStackView.leadingAnchor.constraint(equalTo: majorCurrencyView.leadingAnchor, constant: 6),
            topStackView.trailingAnchor.constraint(equalTo: majorCurrencyView.trailingAnchor, constant: -6),
            topStackView.bottomAnchor.constraint(equalTo: majorCurrencyView.bottomAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: secondCurrencyView.topAnchor, constant: 6),
            bottomStackView.leadingAnchor.constraint(equalTo: secondCurrencyView.leadingAnchor, constant: 6),
            bottomStackView.trailingAnchor.constraint(equalTo: secondCurrencyView.trailingAnchor, constant: -6),
            bottomStackView.bottomAnchor.constraint(equalTo: secondCurrencyView.bottomAnchor, constant: -6)
        ])
        
        NSLayoutConstraint.activate([
            topRightCurrencyPicker.topAnchor.constraint(equalTo: topRightSubView.topAnchor),
            topRightCurrencyPicker.leadingAnchor.constraint(equalTo: topRightSubView.leadingAnchor),
            topRightCurrencyPicker.trailingAnchor.constraint(equalTo: topRightSubView.trailingAnchor),
            topRightCurrencyPicker.bottomAnchor.constraint(equalTo: topRightSubView.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            bottomRightCurrencyPicker.topAnchor.constraint(equalTo: bottomRightSubView.topAnchor),
            bottomRightCurrencyPicker.leadingAnchor.constraint(equalTo: bottomRightSubView.leadingAnchor),
            bottomRightCurrencyPicker.trailingAnchor.constraint(equalTo: bottomRightSubView.trailingAnchor),
            bottomRightCurrencyPicker.bottomAnchor.constraint(equalTo: bottomRightSubView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: topLeftSubView.topAnchor),
            amountTextField.leadingAnchor.constraint(equalTo: topLeftSubView.leadingAnchor),
            amountTextField.trailingAnchor.constraint(equalTo: topLeftSubView.trailingAnchor),
            amountTextField.bottomAnchor.constraint(equalTo: topLeftSubView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: bottomLeftSubView.topAnchor, constant: 4),
            resultLabel.leadingAnchor.constraint(equalTo: bottomLeftSubView.leadingAnchor, constant: 4),
            resultLabel.trailingAnchor.constraint(equalTo: bottomLeftSubView.trailingAnchor, constant: -4),
            resultLabel.bottomAnchor.constraint(equalTo: bottomLeftSubView.bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            convertButton.topAnchor.constraint(equalTo: secondCurrencyView.bottomAnchor, constant: 16),
            convertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            convertButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            convertButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            reverseCurrencyButton.topAnchor.constraint(equalTo: convertButton.bottomAnchor, constant: 8),
            reverseCurrencyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reverseCurrencyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reverseCurrencyButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        
    }
    
    func reverseCurrency() {
        let selectedTop = topRightCurrencyPicker.selectedRow(inComponent: 0)
        let selectedBottom = bottomRightCurrencyPicker.selectedRow(inComponent: 0)
        
        topRightCurrencyPicker.selectRow(selectedBottom, inComponent: 0, animated: true)
        bottomRightCurrencyPicker.selectRow(selectedTop, inComponent: 0, animated: true)
        
        convertCurrency()
    }
    
    
    func convertCurrency() {
        
        let selectedFromRow = bottomRightCurrencyPicker.selectedRow(inComponent: 0)
        let selectedToRow = topRightCurrencyPicker.selectedRow(inComponent: 0)
        
        let fromCurrency = currencies[selectedFromRow].code
        let toCurrency = currencies[selectedToRow].code
        
        guard let amountText = amountTextField.text,
              let amount = Double(amountText) else {
            print("Invalid amount")
            return
        }
        
        let currentDate = getCurrentDateString()
        let urlString = "https://valyuta.com/api/get_currency_rate_for_app/\(fromCurrency)/\(currentDate)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                return
            }
            
            do {
                let currencyRates = try JSONDecoder().decode([CurrencyRate].self, from: data)

                if let rate = currencyRates.first(where: { $0.from == toCurrency })?.result {
                    print("Currency rate is: \(rate)")
                    let finalResult = amount * rate
                    print("Converted amount is: \(finalResult)")
                    
                    
                    DispatchQueue.main.async {
                        self.resultLabel.text = String(format: "Result is: %.2f", finalResult)
                        print("Updated resultLabel with: Result is: \(finalResult)")
                    }

                } else {
                    print("print else")
                }
                
            } catch {
                print("Failed to decode: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    
    
    
    
    func fetchCurrencyList(completion: @escaping (CurrencyList?) -> Void) {
        let urlString = "https://valyuta.com/api/get_currency_list_for_app"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Failed to fetch data: \(error?.localizedDescription ?? "No error description")")
                completion(nil)
                return
            }
            
            do {
                let currencyList = try JSONDecoder().decode(CurrencyList.self, from: data)
                DispatchQueue.main.async {
                    self.currencies = currencyList
                    self.topRightCurrencyPicker.reloadAllComponents()
                    self.bottomRightCurrencyPicker.reloadAllComponents()
                }
                completion(currencyList)
            } catch {
                print("Failed to decode: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    
    
    
    
    
    
    func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].code
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    @objc func convertButtonPressed() {
        convertCurrency()
    }
    
    @objc func reverseButtonPressed() {
        reverseCurrency()
    }
    
    
    
}
