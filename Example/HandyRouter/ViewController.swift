//
//  ViewController.swift
//  HandyRouter
//
//  Created by Shelley on 11/29/2023.
//  Copyright (c) 2023 Shelley. All rights reserved.
//

import UIKit
import HandyRouter

struct URLData {
    let name: String
    let url: String
    
    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}

extension Dictionary where Key == ParameterKey {
    func toArrayValue() -> [String] {
        if let array = self[.arrayTypeDemo] as? [String] {
            return array
        }
        return []
    }
    func toStringValue() -> String {
        if let string = self[.stringTypeDemo] as? String {
            return string
        }
        return ""
    }
}

extension ParameterKey {
    static let arrayTypeDemo: ParameterKey = "arrayTypeDemo"
    static let stringTypeDemo: ParameterKey = "stringTypeDemo"
}

enum RouteJumper: String, Jumper {
    
    case A = "A"
    
    static var module: String {
        return "Module"
    }

     static func jump(to page: RouteJumper, parameters: [HandyRouter.ParameterKey : Any]) -> Bool {
        switch page {
        case .A:
            print("has handled")
            return true
        }
    }
}


class ViewController: UITableViewController {

    let datas: [URLData] = [
        URLData(name: "Common Match",
                url: "handyrouter://commonModule/pageA"),
        URLData(name: "Common Match With parameters",
                url: "handyrouter://commonModule/pageA?paramA=A&paramB=B"),
        URLData(name: "Fragment Match", 
                url: "handyrouter://fragmentModule/pageA#thisIsFragment"),
        URLData(name: "Optional Match", 
                url: "handyrouter://A/C/pageA"),
        URLData(name: "Wildcard Match", 
                url: "handyrouter://wildcardModule/will/match/all/the/following/paths/pageA"),
        URLData(name: "Match Failed", 
                url: "handyrouter://this/url/has/not/been/registered"),
        URLData(name: "Page is Empty",
                url: "handyrouter://empty")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configRouter()
        registerJumper()
    }
    
    func configRouter() {
        Router.shared.defaultRoute.config(options: [.treatHostAsPathComponent])
        Router.shared.defaultRoute.unmatchHandler = { route, resource, params in
            print("scheme = \(route.scheme)",
                  "url = \(resource.url?.absoluteString ?? "")",
                  "parameters = \(params)")
        }
    }
    
    func registerJumper() {
        Router.shared.register(jumper: CommonJumper.self)
        Router.shared.register(jumper: OptionalJumper.self)
        Router.shared.register(jumper: WildcardJumper.self)
        Router.shared.register(jumper: FragmentJumper.self)
        Router.shared.register(jumper: PageEmptyJumper.self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        let data = datas[indexPath.row]
        cell?.textLabel?.text = data.name
        cell?.detailTextLabel?.text = data.url
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datas[indexPath.row]
        Router.shared.route(to: data.url)
    }

}

