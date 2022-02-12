//
//  SideMenuController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/5/22.
//

import UIKit
import Combine

class SideMenuController: UIViewController {
    
    @IBOutlet weak var editeBtn: UIButton! {
        didSet {
            editeBtn.layer.cornerRadius = 5
            editeBtn.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var profileNameLabel: UILabel! {
        didSet {
            profileNameLabel.text = "Manikandan"
        }
    }
    @IBOutlet weak var bdayLabel: UILabel! {
        didSet{
            bdayLabel.text = "13-05-1994 | Manikarthi.vaiha@gmail.com"
        }
    }
    
    @IBOutlet weak var profileContainerView: UIView! {
        didSet{
            profileContainerView.layer.borderWidth = 1
            profileContainerView.layer.borderColor = UIColor.white.cgColor
            profileContainerView.layer.cornerRadius = profileContainerView.frame.height/2
            profileContainerView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var searchTextFeild: UITextField! {
        didSet {
            searchTextFeild.setLeftView(image: UIImage(systemName: "magnifyingglass") ?? UIImage())
            searchTextFeild.placeholder = "search language"
        }
    }
    @IBOutlet weak var addMoreLangeLabele:UILabel!
    
    @IBOutlet weak var searchPeopleBtn: UILabel! {
        didSet {
            searchPeopleBtn.setOnClickListener(userInfo: [:]) { [weak self] _ in
                guard let self = self else { return }
                if let controller = self.getController(controller: SearchPeopleController()) as? SearchPeopleController {
                    let nav = UINavigationController(rootViewController: controller)
                    nav.overrideUserInterfaceStyle = .dark
                    self.present(nav, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBOutlet weak var switchBtn: UISwitch! {
        didSet {
            switchBtn.setOn(MaintainLanguge.shared.adultIsEnable, animated: true)
            switchBtn.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            switchBtn.addTarget(self, action: #selector(adultValueChange), for: .valueChanged)
        }
    }
    
    @objc func adultValueChange(){
        MaintainLanguge.shared.adultIsEnable = switchBtn.isOn
        NotificationCenter.default.post(name: .reloadNotifier, object: nil)
    }
    
    var anyCancellable:Set<AnyCancellable> = Set<AnyCancellable>()
    @IBOutlet weak var countryTable: UITableView!
    typealias TableDataSource = UITableViewDiffableDataSource<Int, LanguageCode>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, LanguageCode>
    
    var lanuguageList:[LanguageCode] = []
    var originalArrayList:[LanguageCode] = []
    lazy var datasource: TableDataSource = {
        let datasource = TableDataSource(tableView: countryTable, cellProvider: { (tableView, indexPath, model) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: LanguageCell.reuseIdentifier, for: indexPath) as? LanguageCell
            cell?.name.text = model.languageName.name
            return cell
        })
        
        return datasource
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMoreLangeLabele.setOnClickListener(userInfo: [:]) { [weak self] _ in
            guard let self = self else { return }
            if let controller = self.getController(controller: ChooseCountryController()) as? ChooseCountryController {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        self.countryTable.keyboardDismissMode = .onDrag
        setupJson()
        searchTextFeild.doneAccessory = true
        searchTextFeild.textPublisher.sink(receiveValue: { [weak self] text in
            guard let self = self else { return }
            self.lanuguageList = self.originalArrayList.filter { code in
                if code.languageName.name.uppercased().contains(text.uppercased()) {
                    return true
                }else if code.languageName.nativeName.uppercased().contains(text.uppercased()) {
                    return true
                }else if code.code.uppercased().contains(text.uppercased()) {
                    return true
                }
                return false
            }
            guard let text = self.searchTextFeild.text else {
                return
            }
            if (!text.isEmpty && self.lanuguageList.isEmpty) {
                self.countryTable.setEmptyMessage("No Language Detected")
            }else{
                if text.isEmpty {
                    self.lanuguageList = self.originalArrayList
                }
                self.countryTable.restore()
            }
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(self.lanuguageList, toSection: 0)
            self.datasource.apply(snapshot)
            self.countryTable.reloadData()
        }).store(in: &anyCancellable)
    }
    
    func setupJson(){
        self.countryTable.keyboardDismissMode = .onDrag
        self.originalArrayList = MaintainLanguge.shared.languageList ?? []
        self.lanuguageList = originalArrayList
        countryTable.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        countryTable.registerNib(nib: LanguageCell.reuseIdentifier)
        countryTable.delegate = self
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(lanuguageList, toSection: 0)
        datasource.apply(snapshot)
        countryTable.reloadData()
    }
}

extension SideMenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect.zero)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        MaintainLanguge.shared.selectedLanguage = lanuguageList[indexPath.row].code
        NotificationCenter.default.post(name: .reloadNotifier, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
}


