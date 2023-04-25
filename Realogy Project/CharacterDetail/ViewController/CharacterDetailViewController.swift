//
//  CharacterDetailViewController.swift
//  Realogy Project
//
//  Created by John Kim on 4/24/23.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    //MARK: - Properties
    var character : Character
    
    //MARK: - Lifecycle methods
    required init(character: Character) {
        self.character = character
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLayout()
        configureConstraints()
    }

    
    //MARK: - UI Properties

    lazy var stackView : UIStackView = {
       let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    lazy var image : UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var nameLabel : UILabel = {
       let nameLabel = UILabel()
        nameLabel.text = character.name
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        return nameLabel
    }()
    
    lazy var descriptionLabel : UILabel = {
       let descriptionLabel = UILabel()
        descriptionLabel.text = character.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    
    //MARK: - Layout Functions
    
    func configureLayout() {
        view.backgroundColor = .white
        
        if let url = URL(string: character.imageUrl ?? "") {
            image.load(url: url)
        }
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    func configureConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    }
    
}

//MARK: - Image Loader
extension UIImageView {
    func load(url: URL) {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async  { [weak self] in
                    self?.image = image
                }
            }
        
    }
}
