//
//  DoseCardView.swift
//  Hack GT 8
//
//  Created by Allen Su on 10/24/21.
//

import UIKit

class DoseCardView: UIView {

    var dose: Dose!
    var titleLabel: UILabel!
    var stackView: UIStackView!
    var doseLabel: UILabel!
    var productLabel: UILabel!
    var productText: UILabel!
    var lotLabel: UILabel!
    var lotText: UILabel!
    var dateLabel: UILabel!
    var dateText: UILabel!
    var siteLabel: UILabel!
    var siteText: UILabel!
    var effectsLabel: UILabel!
    var effectsText: UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateComponents(thisDose: Dose) {
        dose = thisDose
        configureTitleLabel()
        configureVStack()
    }
    
    func configureTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = dose.doseNum
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 300),
            titleLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    func configureVStack() {
        stackView = UIStackView()
        stackView.axis = .vertical
        productLabel = UILabel()
        productText = UILabel()
        let prodView = createView(mainLabel: productLabel, actualLabel: productText, mainText: "Product Name:", actualText: dose.productName)
        lotLabel = UILabel()
        lotText = UILabel()
        let lotView = createView(mainLabel: lotLabel, actualLabel: lotText, mainText: "Manufacturer Lot Number:", actualText: dose.lotNumber)
        dateLabel = UILabel()
        dateText = UILabel()
        let dateView = createView(mainLabel: dateLabel, actualLabel: dateText, mainText: "Date:", actualText: dose.date)
        siteLabel = UILabel()
        siteText = UILabel()
        let siteView = createView(mainLabel: siteLabel, actualLabel: siteText, mainText: "Clinic Site:", actualText: dose.site)
        effectsLabel = UILabel()
        effectsText = UILabel()
        let effectsView = createView(mainLabel: effectsLabel, actualLabel: effectsText, mainText: "Side Effects:", actualText: dose.sideEffects)
        
        stackView.addSubview(prodView)
        stackView.addSubview(lotView)
        stackView.addSubview(dateView)
        stackView.addSubview(siteView)
        stackView.addSubview(effectsView)
        
        self.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    func createView(mainLabel: UILabel, actualLabel: UILabel, mainText: String, actualText: String) -> UIView {
        let prodView = UIView()
        //prodView.translatesAutoresizingMaskIntoConstraints = false
        
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        mainLabel.text = mainText
        prodView.addSubview(mainLabel)
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: prodView.topAnchor, constant: 5),
            mainLabel.leadingAnchor.constraint(equalTo: prodView.leadingAnchor, constant: 10),
            mainLabel.widthAnchor.constraint(equalToConstant: 200),
            mainLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        actualLabel.translatesAutoresizingMaskIntoConstraints = false
        actualLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        actualLabel.text = actualText
        prodView.addSubview(actualLabel)
        NSLayoutConstraint.activate([
            actualLabel.topAnchor.constraint(equalTo: prodView.topAnchor, constant: 5),
            actualLabel.leadingAnchor.constraint(equalTo: prodView.trailingAnchor, constant: -10),
            actualLabel.widthAnchor.constraint(equalToConstant: 200),
            actualLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        return prodView
    }
    
}
