//
//  UIViewController+Extension.swift
//  MoviesMVVM
//
//  Created by Mani on 2/2/22.
//

import Foundation
import UIKit


extension UIViewController:SWRevealViewControllerDelegate {
                
    func getController(controller input: UIViewController) -> UIViewController? {
        return self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: input)))
    }
    func getCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        
        //--------- Group 1 ---------//
        let group1Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        group1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        
        let nestedGroup1Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/2)))
        nestedGroup1Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let nestedGroup2Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1)))
        nestedGroup2Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                        
        let group1 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitems: [group1Item1])
                
        //--------- Group 2 ---------//
        let group2Item1 = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1)))
        group2Item1.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
        
        let group2 = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)), subitems: [group2Item1])
        
        
        //--------- Container Group ---------//
        let containerGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(600)), subitems: [item, group1, group2])
        
        let section = NSCollectionLayoutSection(group: containerGroup)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
        
    }
    
    func setupMenuGestureRecognizer(_ selfController: UIViewController){
        revealViewController().rearViewRevealWidth = selfController.view.frame.width * 0.80
        revealViewController()?.delegate = selfController
    }
    
    public func revealController(_ revealController: SWRevealViewController!, willMoveTo position: FrontViewPosition) {
        let tagId = 112151
        if revealController.frontViewPosition == FrontViewPosition.right {
            let lock = view.viewWithTag(tagId)
            UIView.animate(withDuration: 0.25, animations: {
            }, completion: {(finished: Bool) in
                lock?.removeFromSuperview()
            }
            )
            lock?.removeFromSuperview()
        } else if revealController.frontViewPosition == FrontViewPosition.left {
            let lock = UIView(frame: UIScreen.main.bounds)
            lock.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            lock.tag = tagId
            //            lock.alpha = 0
            lock.backgroundColor = UIColor.clear
            lock.addGestureRecognizer(UITapGestureRecognizer(target: self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:))))
            view.addSubview(lock)
        }
    }
    func add(_ child: UIViewController) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        addChild(child)
        child.view.frame = self.view.bounds
        child.beginAppearanceTransition(true, animated: true)
        view.addSubview(child.view)
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseInOut, animations: {
            child.view.alpha = 1.0
        }, completion: { _ in
            child.endAppearanceTransition()
            child.didMove(toParent: self)
        })
    }
    func remove(_ child: UIViewController) {
        child.beginAppearanceTransition(false, animated: true)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            child.willMove(toParent: nil)
            child.view.alpha = 0.0
        }, completion: { _ in
            child.view.removeFromSuperview()
            child.endAppearanceTransition()
            child.removeFromParent()
        })
    }
}
