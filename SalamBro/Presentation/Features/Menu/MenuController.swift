//
//  MenuController.swift
//  SalamBro
//
//  Created by Arystan on 4/23/21.
//

import UIKit

class MenuController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(UINib(nibName: "MenuCell", bundle: nil), forCellReuseIdentifier: "MenuCell")
        // Do any additional setup after loading the view.
    }

}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        return cell
    }
    
    
}
//class MenuBottomViewController: UIViewController {
//
//    private var categoryCollectionView: UICollectionView!
//    private var menuTableView: UITableView!
//    private var catering: Catering!
//    private var menuList = [FoodType]()
//    private var menu: [Food] = []
//    private var categories: [String] = []
//    private var key: String!
//    private var delegate: MenuContainerProtocol?
//
//    lazy var restaurantTitleLabel: UILabel = {
//        let title = UILabel()
//        title.font = UIFont(name: "AvenirNext-Bold", size: 12)
//        title.textColor = UIColor(red: 74/255, green: 75/255, blue: 77/255, alpha: 1)
//        title.text = "Хачапури Хинкальевич"
//        title.textAlignment = .left
//        title.numberOfLines = 1
//        title.translatesAutoresizingMaskIntoConstraints = false
//        return title
//    }()
//
//    lazy var deliveryTitleLabel: UILabel = {
//        let title = UILabel()
//        title.font = UIFont(name: "AvenirNext-Bold", size: 12)
//        title.textColor = UIColor(red: 74/255, green: 75/255, blue: 77/255, alpha: 1)
//        title.text = "Хачапури Хинкальевич"
//        title.textAlignment = .left
//        title.numberOfLines = 1
//        title.translatesAutoresizingMaskIntoConstraints = false
//        return title
//    }()
//
//    lazy var deliveryPriceLabel: UILabel = {
//        let title = UILabel()
//        title.font = UIFont(name: "AvenirNext-Bold", size: 12)
//        title.textColor = UIColor(red: 74/255, green: 75/255, blue: 77/255, alpha: 1)
//        title.text = "not set"
//        title.textAlignment = .left
//        title.numberOfLines = 1
//        title.translatesAutoresizingMaskIntoConstraints = false
//        return title
//    }()
//
//    lazy var infoButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "info"), for: .normal)
//        button.backgroundColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    lazy var reviewsButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12)
//        button.setTitleColor(UIColor.yellow, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    lazy var deliveryTimeButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = .white
//        button.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 12)
//        button.setTitleColor(UIColor(red: 74/255, green: 75/255, blue: 77/255, alpha: 1), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    lazy var rahmetButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "rahmet"), for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.clipsToBounds = true
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupViews()
//        setupConstraints()
//        [deliveryTimeButton, infoButton, reviewsButton].forEach { makeShadowed(view: $0)
//        }
//
//        let MarketplaceAPI = API(endPoint: MarketplaceEndPoint.fetchRestaurantMenu(self.catering.restaurant.pk))
//        MarketplaceAPI.fetchItems(type: Menu.self) { [self] (result, error) in
//            if let result = result {
//                self.menuList = result.foodTypes
//                for item in self.menuList {
//                    self.categories.append(item.title)
//                    for food in item.foods {
//                        dump(food)
//                        menu.append(food)
//                    }
//                }
//                print(categories)
//                self.categoryCollectionView.reloadData()
//                self.menuTableView.reloadData()
//            } else {
//                fatalError(error.debugDescription)
//            }
//        }
//    }
//
//    func setupViews() {
//        self.view.backgroundColor = .white
//        self.view.layer.cornerRadius = 20
//        self.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//
//        let layout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.scrollDirection = .horizontal
//
//        categoryCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30), collectionViewLayout: layout)
//        categoryCollectionView.showsHorizontalScrollIndicator = false
//        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        categoryCollectionView.dataSource = self
//        categoryCollectionView.delegate = self
//        categoryCollectionView.backgroundColor = .gray
//        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
//
//        menuTableView = UITableView(frame: .zero, style: .plain)
//        menuTableView.showsVerticalScrollIndicator = false
//        menuTableView.translatesAutoresizingMaskIntoConstraints = false
//        menuTableView.dataSource = self
//        menuTableView.delegate = self
//
//        menuTableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
//        restaurantTitleLabel.text = catering.restaurant.title
//        deliveryTitleLabel.text = "Доставка от \(catering.restaurant.title):"
//        reviewsButton.setTitle("⋆ \(catering.restaurant.rating) Отзыва", for: .normal)
//        deliveryTimeButton.setTitle("\(catering.deliveryTime.lowLimitMinutes) - \(catering.deliveryTime.upperLimitMinutes) минут", for: .normal)
//        //        deliveryPrice.text = restaurant.
//
//        view.addSubview(infoButton)
//        view.addSubview(reviewsButton)
//        view.addSubview(deliveryTimeButton)
//        view.addSubview(rahmetButton)
//        view.addSubview(restaurantTitleLabel)
//        view.addSubview(deliveryTitleLabel)
//        view.addSubview(deliveryPriceLabel)
//        view.addSubview(categoryCollectionView)
//        view.addSubview(menuTableView)
//    }
//
//    func setupConstraints() {
//
//        infoButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -3).isActive = true
//        infoButton.centerYAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        infoButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        infoButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        infoButton.layer.cornerRadius = 15
//
//        reviewsButton.rightAnchor.constraint(equalTo: infoButton.leftAnchor, constant: -3).isActive = true
//        reviewsButton.centerYAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        reviewsButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        reviewsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        reviewsButton.layer.cornerRadius = 15
//
//        deliveryTimeButton.rightAnchor.constraint(equalTo: reviewsButton.leftAnchor, constant: -3).isActive = true
//        deliveryTimeButton.centerYAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        deliveryTimeButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
//        deliveryTimeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        deliveryTimeButton.layer.cornerRadius = 15
//
//        rahmetButton.rightAnchor.constraint(equalTo: deliveryTimeButton.leftAnchor, constant: -3).isActive = true
//        rahmetButton.centerYAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        rahmetButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        rahmetButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        rahmetButton.layer.cornerRadius = 15
//
//        restaurantTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        restaurantTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        restaurantTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 18).isActive = true
//
//        deliveryTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        deliveryTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        deliveryTitleLabel.topAnchor.constraint(equalTo: restaurantTitleLabel.bottomAnchor, constant: 15).isActive = true
//
//        deliveryPriceLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        deliveryPriceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        deliveryPriceLabel.topAnchor.constraint(equalTo: deliveryTitleLabel.bottomAnchor, constant: 7).isActive = true
//
//        categoryCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        categoryCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        categoryCollectionView.topAnchor.constraint(equalTo: deliveryPriceLabel.bottomAnchor, constant: 10).isActive = true
//        categoryCollectionView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//
//        menuTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
//        menuTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
//        menuTableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10).isActive = true
//        menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    }
//
//    func passCatering(_ catering: Catering) {
//        self.catering = catering
//    }
//
//    private func registerTableViewCells() {
//        let menuCell = UINib(nibName: "MenuCell",
//                                  bundle: nil)
//        self.menuTableView.register(menuCell, forCellReuseIdentifier: "MenuCell")
//    }
//
//    func makeShadowed(view: UIView) {
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOpacity = 0.2
//        view.layer.shadowOffset = .zero
//        view.layer.shadowRadius = 3
//    }
//}
//
//extension MenuBottomViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categories.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
//        cell.setTitle(categories[indexPath.row])
//        return cell
//    }
//}
//
//extension MenuBottomViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width: CGFloat
//        let height: CGFloat
//        let text = categories[indexPath.row]
//        let textSize = text.size(withAttributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
//        width = textSize.width + 20
//        height = 30
//
//        return .init(width: width, height: height)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//}
//
//extension MenuBottomViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.showBottomSheet()
//        categoryCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//
//        var counter = 0
//        for item in menuList {
//            if item.title == categories[indexPath.row] {
//                break
//            }
//            counter += item.foods.count
//        }
//        let index = IndexPath(row: counter, section: 0)
//        menuTableView.scrollToRow(at: index, at: .top, animated: true)
//    }
//}
//
//extension MenuBottomViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        return self.menu.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
//        cell.setup(data: menu[indexPath.row])
//        dump(menu[indexPath.row])
//        return cell
//    }
//
////    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        menuTableView.deselectRow(at: indexPath, animated: true)
////    }
//
//}
//
//extension MenuBottomViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
//}


