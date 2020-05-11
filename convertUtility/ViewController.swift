//
//  ViewController.swift
//  convertUtility
//
//  Created by Diogenes de Souza on 24/04/19.
//  Copyright © 2019 Empresa pessoal. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    var moedas: [moeda] = []
    
    var bannerView: GADBannerView!
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var userEnter: UITextField!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultText: UILabel!
    @IBOutlet weak var titleScreen: UILabel!
    @IBOutlet weak var buttonUpdate: UIButton!
    
    @IBOutlet weak var cotacao: UITextField!
    @IBOutlet weak var enterText: UILabel!
    
    @IBOutlet  weak var dolarIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cotacaoText: UILabel!
    
    @IBAction func updateDolar(_ sender: UIButton) {
        
           self.dolarIndicator.startAnimating()
        
        cotacao.placeholder = ""
        cotacaoText.text = ""
        result.text = ""
        resultText.text = ""
        enterText.text = ""
        cotacao.text = ""
        
        REST.loadMoedas(onComplete: { (arrayMoedas) in
         
            print("Cota mais alta do Real: \(arrayMoedas[0].high)")
            
            //executar na thread principal
            DispatchQueue.main.async {
             
                self.moedas = arrayMoedas
                self.cotacao.text! = arrayMoedas[0].high
                self.cotacaoText.text! = NSLocalizedString("textoDaCotacao", comment: "") + arrayMoedas[0].create_date
                self.dolarIndicator.stopAnimating()
               
            }
            
             
            
        }) { (error) in
            
            switch error {
            case .invalidJASON:
                print(" Erro, JASON INVÁLIDO")
                self.cotacaoText.text! = NSLocalizedString("falhaInternet", comment: "")
                
            case .url:
                print(" Erro na URL")
                self.cotacaoText.text! = NSLocalizedString("falhaInternet", comment: "")
                
            case .taskError(let error):
                print(" Erro ao realizar a tarefa:  \(error)")
//                self.cotacaoText.text! = NSLocalizedString("falhaInternet", comment: "")
                self.cotacaoText.text! = NSLocalizedString("falhaInternet", comment: "")
              
                
            case .noResponse:
                print(" Erro, o servidor não respondeu")
                self.cotacaoText.text! = NSLocalizedString("falhaInternet", comment: "")
                 
                
            case .noData:
                print(" Erro, não há dados validos no JSON")
                self.cotacaoText.text! = NSLocalizedString("falhaInternet", comment: "")
                
            case .responseStatusCode(let code):
                print("Erro, resposta do servidor inesperada: \(code)" )
                self.cotacaoText.text! = NSLocalizedString("falhaInternet", comment: "")
                
         
            }
             self.dolarIndicator.stopAnimating()
         
        }
    

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // In this case, we instantiate the banner with desired ad size.
        
       
        
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-7764785023267812/1930155425")
        let request = GADRequest()
        interstitial.load(request)
        
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-7764785023267812/7717567099"
        bannerView.rootViewController = self
        
        addBannerViewToView(bannerView)
        
        dolarIndicator.hidesWhenStopped = true
        
        
        print("carregou view controle")
        
        //
        //        REST.loadMoedas(TitleDateCota: cotacaoText, valorCotacaoTextField: cotacao, indicator: dolarIndicator) //Atualiza o valor do dólar
        
        //        dolarIndicator.stopAnimating()
        
        bannerView.load(GADRequest())
        
//         updateDolar(button1)
        
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    
    @IBAction func backTitle(_ sender: UIButton) {
        
        switch titleScreen.text {
        case "Moeda", "Currency":
            titleScreen.text = NSLocalizedString("peso", comment: "")
            button1.setTitle(NSLocalizedString("quilograma", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("libra", comment: "") , for:.normal)
            buttonUpdate.isHidden = true
            cotacao.isHidden = true
            cotacaoText.text! = ""
            
        case "Peso", "Weight":
            titleScreen.text = NSLocalizedString("distancia", comment: "")
            button1.setTitle(NSLocalizedString("quilometro", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("milha", comment: "") , for:.normal)
            buttonUpdate.isHidden = true
            cotacao.isHidden = true
            cotacaoText.text! = ""
            
        case "Distância", "Distance":
            titleScreen.text = NSLocalizedString("temperatura", comment: "")
            button1.setTitle(NSLocalizedString("celsius", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("faren", comment: "") , for:.normal)
            
        case "Temperatura", "Temperature":
            titleScreen.text = NSLocalizedString("velocidade", comment: "")
            button1.setTitle(NSLocalizedString("mPorSeg", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("kmPorHora", comment: "") , for:.normal)
            buttonUpdate.isHidden = true
            cotacao.isHidden = true
            cotacaoText.text! = ""
            
            
        default:
            titleScreen.text = NSLocalizedString("moeda", comment: "")
            button1.setTitle(NSLocalizedString("real", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("dolar", comment: "") , for:.normal)
            buttonUpdate.isHidden = false
            cotacao.isHidden = false
            cotacaoText.text! = ""
            
        }
        
        convert(nil)
        view.endEditing(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        convert(nil)
        view.endEditing(true)
    }
    
    func displayLoadindDolar(){
        
    }
    
    @IBAction func nextTitle(_ sender: UIButton) {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
            interstitial = GADInterstitial(adUnitID: "ca-app-pub-7764785023267812/1930155425")
            let request = GADRequest()
            interstitial.load(request)
        } else {
            print("Ad wasn't ready")
        }
        
        switch titleScreen.text! {
            
        case "Temperatura", "Temperature":
            titleScreen.text = NSLocalizedString("distancia", comment: "")
            button1.setTitle(NSLocalizedString("quilometro", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("milha", comment: "") , for:.normal)
            
        case "Distância", "Distance":
            titleScreen.text = NSLocalizedString("peso", comment: "")
            button1.setTitle(NSLocalizedString("quilograma", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("libra", comment: "") , for:.normal)
            
        case "Peso", "Weight":
            
            titleScreen.text = NSLocalizedString("moeda", comment: "")
            button1.setTitle(NSLocalizedString("real", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("dolar", comment: "") , for:.normal)
            buttonUpdate.isHidden = false
            cotacao.isHidden = false
            cotacaoText.text! = ""
            
        case "Moeda", "Currency":
            titleScreen.text = NSLocalizedString("velocidade", comment: "")
            button1.setTitle(NSLocalizedString("mPorSeg", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("kmPorHora", comment: "") , for:.normal)
            buttonUpdate.isHidden = true
            cotacao.isHidden = true
            cotacaoText.text! = ""
            
        default:
            titleScreen.text = NSLocalizedString("temperatura", comment: "")
            button1.setTitle(NSLocalizedString("celsius", comment: ""), for: .normal)
            button2.setTitle(NSLocalizedString("faren", comment: "") , for:.normal)
        }
        
        convert(nil)
        view.endEditing(true)
        
    }
    
    
    @IBAction func convert(_ sender: UIButton?) {
        
        if let buttonSelect = sender{
            if buttonSelect == button1{
                button2.alpha = 0.5
            }else{
                button1.alpha = 0.5
            }
            
            buttonSelect.alpha = 1.0
            
        }
        
        switch titleScreen.text! {
        case "Moeda", "Currency":
            calcCurrency()
        case "Peso", "Weight":
            calcWeight()
        case "Distância", "Distance":
            calcDist()
        case "Temperatura", "Temperature":
            calcTemp()
        default:
            calcSpeed()
        }
        
        
    }
    
    
    func calcCurrency(){
        
        let moeda = userEnter.text!
        let cota =  cotacao.text!
    
        guard let currency = Double(moeda.replacingOccurrences(of: ",", with: "."))  else {
            return
        }
        
        guard let cotacaoDia =  Double(cota.replacingOccurrences(of: ",", with: "."))  else {
            return
        }
        
        if button1.alpha == 1.0{
            result.text = String(format: "%.2f",currency * cotacaoDia)
            resultText.text = NSLocalizedString("real", comment: "")
            enterText.text = NSLocalizedString("dolar", comment: "")
        }else{
            result.text = String( format:"%.2f" ,currency / cotacaoDia)
            resultText.text = NSLocalizedString("dolar", comment: "")
            enterText.text = NSLocalizedString("real", comment: "")
        }
        
    }
    func  calcWeight(){
        
        guard let peso = Double(userEnter.text!)  else {
            return
        }
        if button1.alpha == 1.0{
            result.text = String(peso / 2.20462)
            resultText.text = NSLocalizedString("quilograma", comment: "")
            enterText.text = NSLocalizedString("libra", comment: "")
        }else{
            result.text = String( peso * 2.20462)
            resultText.text = NSLocalizedString("libra", comment: "")
            enterText.text = NSLocalizedString("quilograma", comment: "")
        }
        
    }
    func  calcDist(){
        
        guard let dist = Double(userEnter.text!)  else {
            return
        }
        if button1.alpha == 1.0{
            result.text = String( dist / 0.621371)
            resultText.text = NSLocalizedString("quilometro", comment: "")
            enterText.text = NSLocalizedString("milha", comment: "")
        }else{
            result.text = String(  dist * 0.621371)
            resultText.text = NSLocalizedString("milha", comment: "")
            enterText.text = NSLocalizedString("quilometro", comment: "")
        }
        
    }
    func calcTemp(){
        
        guard let temp = Double(userEnter.text!)  else {
            return
        }
        if button2.alpha == 1.0{
            result.text = String(temp * 1.8 + 32.0)
            resultText.text = NSLocalizedString("faren", comment: "")
            enterText.text = NSLocalizedString("celsius", comment: "")
        }else{
            result.text = String( (temp - 32.0 ) / 1.8)
            resultText.text = NSLocalizedString("celsius", comment: "")
            enterText.text = NSLocalizedString("faren", comment: "")
        }
        
    }
    
    func calcSpeed(){
        
        guard let speed = Double(userEnter.text!)  else {
            return
        }
        if button1.alpha == 1.0{
            result.text = String(speed / 3.6)
            resultText.text = NSLocalizedString("mPorSeg", comment: "")
            enterText.text = NSLocalizedString("kmPorHora", comment: "")
        }else{
            result.text = String( speed * 3.6)
            resultText.text = NSLocalizedString("kmPorHora", comment: "")
            enterText.text = NSLocalizedString("mPorSeg", comment: "")
            
        }
        
    }
    
}
