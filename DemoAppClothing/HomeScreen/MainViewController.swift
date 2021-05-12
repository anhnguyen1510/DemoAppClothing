//
//  MainViewController.swift
//  NoStoryboard
//
//  Created by Anhnguyen on 06/05/2021.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var itemCollectioView: UICollectionView!
    @IBOutlet weak var slideHomeCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    var sildeImages = [UIImage(named: "slideHomeImage"),
                       UIImage(named: "slideHomeImage1"),
                       UIImage(named: "slideHomeImage2"),
                       UIImage(named: "slideHomeImage3")]
    var productImages = [UIImage(named: "shirt"),
                        UIImage(named: "watch"),
                        UIImage(named: "bags"),
                        UIImage(named: "duffleBags"),
                        UIImage(named: "coats"),
                        UIImage(named: "homeAndCamp")
    ]
    var timer = Timer()
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        setupPageView()
    }

    func setupNavigationBar() {
        //title logo
        let logo = UIImage(named: "logoApp")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        //background
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.tintColor = .white
        //button bar
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu") , style: .plain, target: self, action: #selector(tapMenu))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "search"), style: .plain, target: self, action: #selector(tapSearch))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    func setupCollectionView () {
        let nibSildeImageCell = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        slideHomeCollectionView.register(nibSildeImageCell, forCellWithReuseIdentifier: "sildeImageCell")
        let nibProductCell = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        itemCollectioView.register(nibProductCell, forCellWithReuseIdentifier: "productCell")
    }
    
    func setupPageView() {
        pageView.numberOfPages = sildeImages.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    @objc func changeImage() {
        if counter < sildeImages.count {
            let index = IndexPath(item: counter, section: 0)
            self.slideHomeCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath(item: counter, section: 0)
            self.slideHomeCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
    @objc func tapMenu() {
        print("tap menu")
    }
    
    @objc func tapSearch() {
        print("tap search")
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == slideHomeCollectionView {
            return sildeImages.count
        }
        return productImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == slideHomeCollectionView {
            let slideImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "sildeImageCell", for: indexPath) as! ImageCollectionViewCell
            slideImageCell.slideImageView.image = sildeImages[indexPath.row]
            return slideImageCell
        } else if collectionView == itemCollectioView {
            let productImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCollectionViewCell
            productImageCell.productImageView.image = productImages[indexPath.row]
            return productImageCell
        }
        return UICollectionViewCell()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        counter = Int(ceil(x/w))
    }
}

extension MainViewController:  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == slideHomeCollectionView {
            return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
        }
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size:CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
    
}
