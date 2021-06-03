//
//  RatingController.swift
//  DetailView
//
//  Created by Arystan on 5/2/21.
//

import UIKit

class RatingController: ViewController {
    var coordinator: RatingCoordinator
    
    lazy var segmentedControlView: CustomSegmentedControl = {
        let view = CustomSegmentedControl(buttonTitle: [L10n.Rating.overall, L10n.Rating.weekly])
        view.selectorViewColor = .kexRed
        view.selectorTextColor = .white
        view.setIndex(index: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var outerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 17.0
        view.layer.borderColor = UIColor.kexRed.cgColor
        view.layer.borderWidth = 1.0
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

//    lazy var periodLabel: UILabel = {
//        let view = UILabel()
//        view.text = "ПЕРИОД С 1.03.21 ПО 7.03.21"
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()

    lazy var placeLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.Rating.place
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.textColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var userLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.Rating.user
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.textColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var sumLabel: UILabel = {
        let view = UILabel()
        view.text = L10n.Rating.sum
        view.font = .systemFont(ofSize: 10, weight: .medium)
        view.textColor = .mildBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var infoButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "info"), for: .normal)
        view.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var ratingTable: UITableView = {
        let view = UITableView()
        view.separatorColor = .mildBlue
        view.register(RatingCell.self, forCellReuseIdentifier: "RatingCell")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.delegate = self
        view.dataSource = self
        view.showsVerticalScrollIndicator = false
        view.estimatedRowHeight = 70
        view.separatorInset = .zero
        view.tableFooterView = UIView()
        return view
    }()

    lazy var participationView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var participateButton: UIButton = {
        let view = UIButton()
        view.backgroundColor = .kexRed
        view.setTitle(L10n.Rating.participate, for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(coordinator: RatingCoordinator) {
        self.coordinator = coordinator
        
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        coordinator.didFinish()
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()
        navigationItem.title = L10n.Rating.title
        navigationItem.rightBarButtonItem = .init(customView: infoButton)
    }
}

extension RatingController {
    func setupViews() {
        view.backgroundColor = .white
        outerView.addSubview(segmentedControlView)
        participationView.addSubview(divider)
        participationView.addSubview(participateButton)
        [placeLabel, userLabel, sumLabel, outerView, ratingTable, participationView].forEach {
            view.addSubview($0)
        }
    }

    func setupConstraints() {
        placeLabel.topAnchor.constraint(equalTo: outerView.bottomAnchor, constant: 16).isActive = true
        placeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true

        userLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        userLabel.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true

        sumLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        sumLabel.centerYAnchor.constraint(equalTo: placeLabel.centerYAnchor).isActive = true

        outerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        outerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        outerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        outerView.heightAnchor.constraint(equalToConstant: 34).isActive = true

        segmentedControlView.topAnchor.constraint(equalTo: outerView.topAnchor).isActive = true
        segmentedControlView.leftAnchor.constraint(equalTo: outerView.leftAnchor).isActive = true
        segmentedControlView.rightAnchor.constraint(equalTo: outerView.rightAnchor).isActive = true
        segmentedControlView.bottomAnchor.constraint(equalTo: outerView.bottomAnchor).isActive = true

        ratingTable.topAnchor.constraint(equalTo: placeLabel.bottomAnchor).isActive = true
        ratingTable.leftAnchor.constraint(equalTo: participationView.leftAnchor, constant: 24).isActive = true
        ratingTable.rightAnchor.constraint(equalTo: participationView.rightAnchor, constant: -24).isActive = true
        ratingTable.bottomAnchor.constraint(equalTo: participationView.topAnchor).isActive = true

        divider.topAnchor.constraint(equalTo: participationView.topAnchor).isActive = true
        divider.leftAnchor.constraint(equalTo: participationView.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: participationView.rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true

        participateButton.centerYAnchor.constraint(equalTo: participationView.centerYAnchor).isActive = true
        participateButton.leftAnchor.constraint(equalTo: participationView.leftAnchor, constant: 24).isActive = true
        participateButton.rightAnchor.constraint(equalTo: participationView.rightAnchor, constant: -24).isActive = true
        participateButton.heightAnchor.constraint(equalToConstant: 43).isActive = true

        participationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        participationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        participationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        participationView.heightAnchor.constraint(equalToConstant: 75).isActive = true
    }

    @objc func infoButtonTapped() {
        coordinator.openAgreement()
    }
}

extension RatingController: CustomSegmentedControlDelegate {
    func change(to _: Int) {
        print("changed")
    }
}

extension RatingController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        70
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        15
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        cell.selectionStyle = .none
        cell.bindData(place: indexPath.row + 1, name: "Джон До\(indexPath.row + 1)", link: "johndoe", price: "999 000")
        switch indexPath.row {
        case 0:
            cell.placeImageView.image = UIImage(named: "firstPlace")
            cell.placeLabel.isHidden = true
        case 1:
            cell.placeImageView.image = UIImage(named: "secondPlace")
            cell.placeLabel.isHidden = true
        case 2:
            cell.placeImageView.image = UIImage(named: "thirdPlace")
            cell.placeLabel.isHidden = true
        default:
            break
        }
        return cell
    }
}
