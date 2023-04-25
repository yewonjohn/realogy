//
//  CharacterListViewController.swift
//  Realogy Project
//
//  Created by John Kim on 4/24/23.
//

import UIKit

class CharacterListViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel : CharacterListViewModelProtocol
    var characters : [Character] = []
    var filteredCharacters : [Character] = []
    var currentPackage : CharacterPackages = .simpsons
    
    
    //MARK: - Lifecycle Functions
    required init(viewModel: CharacterListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
        configureConstraints()
        fetchCharacters(currentPackage)
    }
    
    //MARK: - UI Properties
    
    lazy var characterSwitcherButton : UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "cube"), style: .plain, target: self, action: #selector(switchPackage))
        return button
    }()
    
    lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "Search Characters"
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = searchController.searchBar
        return tableView
    }()
    
    //MARK: - Layout Functions
    
    func configureViews() {
        view.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = characterSwitcherButton
        view.addSubview(tableView)
    }
    
    func configureConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    //MARK: - Operation Functions
    
    func fetchCharacters(_ package : CharacterPackages) {
        viewModel.fetchCharacters(package){ [weak self] (characters) in
            DispatchQueue.main.async {
                self?.characters = characters
                self?.tableView.reloadData()
            }
        }
    }
    
    func filterCharacters(_ searchInput: String) {
        filteredCharacters = characters.filter({ (character:Character) -> Bool in
            let nameFilter = character.name?.range(of: searchInput, options: NSString.CompareOptions.caseInsensitive)
            let descriptionFilter = character.description?.range(of: searchInput, options: NSString.CompareOptions.caseInsensitive)
            return nameFilter != nil || descriptionFilter != nil
        })
    }
    
    @objc func switchPackage() {
        if(currentPackage == .simpsons){
            currentPackage = .theWire
        } else {
            currentPackage = .simpsons
        }
        
        fetchCharacters(currentPackage)
    }
    
}
//MARK: - TableView Delegate
extension CharacterListViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.isActive ? filteredCharacters.count : characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let character = searchController.isActive ? filteredCharacters[indexPath.row] : characters[indexPath.row]
        cell.textLabel?.text = character.name
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if(searchController.isActive){
            present(CharacterDetailViewController(character: filteredCharacters[indexPath.row]), animated: true)
        } else {
            present(CharacterDetailViewController(character: characters[indexPath.row]), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return searchController.isActive ? true : false
    }
}

//MARK: - Search Bar Delegate
extension CharacterListViewController : UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterCharacters(searchText)
            tableView.reloadData()
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
}
