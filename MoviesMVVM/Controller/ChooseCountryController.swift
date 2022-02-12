//
//  ChooseCountryController.swift
//  MoviesMVVM
//
//  Created by Mani on 2/10/22.
//

import UIKit
import Combine

class ChooseCountryController: UIViewController {
    @IBOutlet weak var topContainerBtn: UIView!
    @IBOutlet weak var contineuBtn: UIButton!
    @IBOutlet weak var LangTableview: UITableView!
    lazy var searchBar:UISearchBar = UISearchBar()
    private lazy var binding: Set<AnyCancellable> = Set<AnyCancellable>()
    typealias DataSource = UITableViewDiffableDataSource<Int, LanguageCode>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, LanguageCode>
    var fillteredList: [LanguageCode]? = []
    var orignalList: [LanguageCode]? = []
    lazy var dataSource = makeDataSource()
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(tableView: LangTableview, cellProvider: {( tableView, indexPath, lang) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: ChooseLanguageCell.reuseIdentifier, for: indexPath) as? ChooseLanguageCell
            cell?.checkMarkImage.image = UIImage(systemName: lang.selectBool ?  "checkmark.seal.fill":  "checkmark.seal")
            cell?.LangName = lang.languageName.name
            return cell
        })
        return dataSource
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        LangTableview.keyboardDismissMode = .onDrag
        setupJSON()
        topContainerBtn.setOnClickListener(userInfo: [:]) { [weak self] _ in
            guard let self = self else { return }
            self.topContainerBtn.endEditing(true)
        }
        contineuBtn.addAction(UIAction(handler: { action in
            if let isEmpty = self.orignalList?.filter({ code in
                return code.selectBool
            }).isEmpty {
                if isEmpty {
                    TTGSnackbar(message: "Please select country", duration: .short).show()
                }else{
                    MaintainLanguge.shared.languageList = self.orignalList?.filter({ code in
                        return code.selectBool
                    })
                    MaintainLanguge.shared.languageList = MaintainLanguge.shared.languageList?.sorted(by: { a1, a2 in
                        a1.selectBool && !a2.selectBool
                    })
                    MaintainLanguge.shared.selectedLanguage = MaintainLanguge.shared.languageList?.first?.code ?? ""
                    self.redirectHomePage()
                }
            }
        }), for: .touchUpInside)
        
        
    }
    
    func redirectHomePage(){
        let story = UIStoryboard(name: "Main", bundle: nil)
        let frontController = UINavigationController(rootViewController: story.instantiateViewController(withIdentifier: "HomeViewController"))
        
        let rearViewController = story.instantiateViewController(withIdentifier: "SideMenuController")
        
        if let swRevealVC = SWRevealViewController(rearViewController: rearViewController, frontViewController: frontController) {
            swRevealVC.toggleAnimationType = SWRevealToggleAnimationType.easeOut;
            swRevealVC.toggleAnimationDuration = 0.30;
            swRevealVC.delegate = self
            let nav_controller = UINavigationController(rootViewController: swRevealVC)
            nav_controller.navigationBar.isHidden = true
            nav_controller.overrideUserInterfaceStyle = .dark
            nav_controller.setNavigationBarHidden(false, animated: true)
            UIWindow.key?.rootViewController = nav_controller
            UIWindow.key?.makeKeyAndVisible()
            if let window = UIWindow.key {
                UIView.transition(with: window, duration: 0.3, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {}, completion:
                                    { completed in
                })
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        LangTableview.layer.cornerRadius = 15
        LangTableview.layer.masksToBounds = true
        LangTableview.layer.borderWidth = 0.6
        LangTableview.layer.borderColor = UIColor.white.cgColor
    }
}


extension ChooseCountryController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return}
        var updatedSelectedItem = selectedItem
        updatedSelectedItem.selectBool.toggle()
        TTGSnackbar(message: selectedItem.languageName.name + (updatedSelectedItem.selectBool ? " add to favourite" : " remoeved from your favourite"), duration: .short).show()
        if let fillterIndex = fillteredList?.firstIndex(of: selectedItem) {
            fillteredList?[fillterIndex] = updatedSelectedItem
        }
        if let index = orignalList?.firstIndex(of: selectedItem) {
            orignalList?[index] = updatedSelectedItem
        }
        var newSnapShot = dataSource.snapshot()
        newSnapShot.insertItems([updatedSelectedItem], beforeItem: selectedItem)
        newSnapShot.deleteItems([selectedItem])
        dataSource.apply(newSnapShot, animatingDifferences: false)
    }
    
}

extension ChooseCountryController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
        view.backgroundColor = .clear
        searchBar.searchBarStyle = .prominent
        searchBar.barTintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = true
        searchBar.backgroundImage = UIImage()
        view = searchBar
        searchBar.searchTextField.doneAccessory = true
        searchBar.searchTextField.textPublisher.sink { completion in
        } receiveValue: { [weak self] searchText in
            guard let self = self else { return }
            self.fillteredList = self.orignalList?.filter({ respo in
                if respo.languageName.name.uppercased().contains(searchText.uppercased()) {
                    return true
                }else{
                    return false
                }
            })
            guard let text = self.searchBar.searchTextField.text else {
                return
            }
            if (!text.isEmpty && self.fillteredList?.isEmpty ?? false) {
                self.LangTableview.setEmptyMessage("No Language Detected")
            }else{
                if text.isEmpty {
                    self.fillteredList = self.orignalList
                }
                self.LangTableview.restore()
            }
            var snapshot = Snapshot()
            snapshot.appendSections([0])
            snapshot.appendItems(self.fillteredList ?? [], toSection: 0)
            self.dataSource.apply(snapshot)
        }.store(in: &binding)
        return view
    }
    
    func setupJSON(){
        let data = MaintainLanguge.shared.language.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [String:String]] {
                jsonArray.forEach { repo in
                    let value = repo.value
                    let lang = LanguageCode(selectBool: false, code: repo.key , languageName: LanguageModel(name: value["name"] ?? "", nativeName: value["nativeName"] ?? ""))
                    orignalList?.append(lang)
                }
                
                MaintainLanguge.shared.languageList?.forEach({ lang in
                    let index = orignalList?.first(where: { code in
                        code.code == lang.code
                    })
                    if let index = index {
                        if let index = orignalList?.firstIndex(of: index) {
                            orignalList?[index] = lang
                        }
                    }
                })
                
                orignalList = orignalList?.sorted(by: { $0.languageName.name.lowercased() < $1.languageName.name.lowercased() })
                
                if !(MaintainLanguge.shared.languageList?.isEmpty ?? false) {
                    orignalList = orignalList?.sorted(by: { a1, a2 in
                        a1.selectBool && !a2.selectBool
                    })
                }
                fillteredList = orignalList
                setup()
            }
        } catch {
            print(error)
        }
    }
    
    func setup(){
        LangTableview.registerNib(nib: ChooseLanguageCell.reuseIdentifier)
        LangTableview.delegate = self
        LangTableview.backgroundColor = UIColor.clear
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(fillteredList ?? [] , toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
