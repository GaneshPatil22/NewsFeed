//
//  ViewController.swift
//  NewsFeed
//
//  Created by MacMini 20 on 8/26/20.
//  Copyright © 2020 MacMini 20. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: UI Elements
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Search"
        return tf
    }()
    
    let searchButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .gray
        btn.setTitle("Search", for: .normal)
        btn.addTarget(self, action: #selector(fetchNews), for: .touchUpInside)
        return btn
    }()
    
    let articleTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.tableFooterView = UIView()
        return tv
    }()
    
    let noDataAvailableLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Please search something such as \"Bitcoin\""
        lbl.numberOfLines = 0
        lbl.textAlignment = .center
        lbl.textColor = .gray
        return lbl
    }()
    
    //MARK:- Variables and constants
    var articles: [Article] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.noDataAvailableLabel.text = "No Data Available"
                self?.noDataAvailableLabel.isHidden = !(self?.articles.count == 0)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUpView()
        setUpDelegates()
    }
    
    private func setUpView() {
        //MARK:- Add elements to view
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        view.addSubview(articleTableView)
        view.addSubview(noDataAvailableLabel)
        
        //MARK: Set up constraints
        searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 30).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchButton.topAnchor.constraint(equalTo: searchTextField.topAnchor).isActive = true
        searchButton.leftAnchor.constraint(equalTo: searchTextField.rightAnchor, constant: 10).isActive = true
        searchButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        articleTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10).isActive = true
        articleTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        articleTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        articleTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
        
        noDataAvailableLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noDataAvailableLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noDataAvailableLabel.widthAnchor.constraint(equalTo: articleTableView.widthAnchor).isActive = true
    }
    
    private func setUpDelegates() {
        
        searchTextField.delegate = self
        searchTextField.returnKeyType = .done
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
        articleTableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: CellIdentifier.ArticleTableViewCell.rawValue)
    }

    @objc private func fetchNews() {
        let searchText = searchTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        NetworkHelper<ArticleDataModel>.APICall(APIPath.FetchNews(searchText).description, searchText: (searchTextField.text ?? "")){ [weak self] result in
                switch result {
                case .failure(let err):
                    AppUtil.showMessage("\(err.localizedDescription)", messageTitle: Messages.Fail.rawValue , buttonTitle: Messages.Ok.rawValue)
                case .success(let model):
                    self?.articles = model.data
                    DispatchQueue.main.async {
                        self?.articleTableView.reloadData()
                    }
                }
            }
        }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.ArticleTableViewCell.rawValue, for: indexPath) as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.selectionStyle = .none
        cell.setUpData(model: article)
        return cell
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        fetchNews()
        return true
    }
}
