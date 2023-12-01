//
//  ModuleDetailViewController.swift
//  HandyRouter_Example
//
//  Created by 邹贤琳 on 2023/11/29.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit
import HandyRouter

extension Dictionary where Key == ParameterKey, Value: Any {
    
    func toString() -> String {
        let concatenatedPairs: [String] = self.compactMap { key, value in
            if let stringValue = value as? String {
                return "\(key)=\(stringValue)"
            } else if let stringArray = value as? [String] {
                let arrayString = stringArray.joined(separator: ",")
                return "\(key)=\(arrayString)"
            } else {
                return nil
            }
        }

        let result = concatenatedPairs.joined(separator: "\n")
        return result
    }
}

class ModuleDetailViewController: UIViewController {

    @IBOutlet weak var jumperNameLabel: UILabel!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var pageNameLabel: UILabel!
    @IBOutlet weak var paramLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    var jumperName = ""
    var moduleName = ""
    var pageName = ""
    var parameters = ""
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.jumperNameLabel.text = "Jumper Class Name: \(jumperName)"
        self.moduleNameLabel.text = "Module Name: \(moduleName)"
        self.pageNameLabel.text = "Page Name: \(pageName)"
        self.paramLabel.text = "Parameters Value: \n\(parameters)"
        self.urlLabel.text = "Url: \(url)"
    }
    
    class func instantiate(jumperName: String,
                           moduleName: String,
                           pageName: String,
                           parameters: String,
                           url: String) -> ModuleDetailViewController {
        let sceneStoryboard = UIStoryboard(name: String(describing: self), bundle: Bundle(for: self))
        let viewController = sceneStoryboard.instantiateInitialViewController()
        guard let typedViewController = viewController as? Self else {
          fatalError("The initialViewController of '\(sceneStoryboard)' is not of class '\(self)'")
        }
        typedViewController.jumperName = jumperName
        typedViewController.moduleName = moduleName
        typedViewController.pageName = pageName
        typedViewController.parameters = parameters
        typedViewController.url = url
        return typedViewController
    }
}
