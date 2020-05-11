//
//  REST.swift
//  convertUtility
//
//  Created by Diogenes de Souza on 27/04/19.
//  Copyright © 2019 Empresa pessoal. All rights reserved.
//

import Foundation
import UIKit


enum MoedaErro {
    case url
    case taskError(error:Error)
    case noResponse
    case noData
    case responseStatusCode(code: Int)
    case invalidJASON
}

class REST{
    
    
    
    private static let basePhath = "https://economia.awesomeapi.com.br/USD-BRL"
    private static let configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 20.0
        config.httpMaximumConnectionsPerHost = 5
       
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)      //URLSession.shared
    
    
    
    class func loadMoedas(onComplete: @escaping ([moeda])-> Void, onError: @escaping (MoedaErro)-> Void){
        
guard let url = URL(string: basePhath) else{
            onError(.url)
            return
            
        }
        
        let dataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, erro: Error?) in
            
            if erro == nil{
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                    
                }
                
                if response.statusCode == 200{
                    guard let data = data else{return}
                    
                    do{
                        let valores = try JSONDecoder().decode([moeda].self, from: data)
                        
                        print("rodou valores:" +   valores[0].high)
                        
              onComplete(valores)
                        
                    }catch{
                        onError(.invalidJASON)
                        return
                    }
                    
                }else{
//                    print(" rodou Inválido pelo servidor!")
                    onError(.responseStatusCode(code: response.statusCode))
//                    indicator.stopAnimating()
                    
                    return
                    
                }
                
            }else{
                print(erro!)
//
                print(" rodou Valor do dólar indisponível no momento! \(erro!)")
                
                onError(.taskError(error: erro!))
                
                
                return

            }
        }
        dataTask.resume()
        
        
        
        
    }
}
