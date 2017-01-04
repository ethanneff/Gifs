//
//  ChildViewController2.swift
//  GifsVideosScroll
//
//  Created by Ethan Neff on 8/5/16.
//  Copyright © 2016 Ethan Neff. All rights reserved.
//

// TODO: refresh button
// TODO: search button (change title)
// TODO: hold action sheet (share)
// TODO: popups... review, feedback, update
// TODO: network dropdown
// TODO: try again - only download the needed network request

// TODO: click expand and side swipe
// TODO: change title on search
// TODO: pull trending first
// TODO: do searhc instead of random
// TODO: click to full screen (slide scroll view)
// TODO: hold to copy to clipboard

import UIKit
import CHTCollectionViewWaterfallLayout

class GifsViewController: UIViewController {
    // MARK: - properties
    fileprivate let imageWidth: CGFloat = 100
    fileprivate let batch: Int = 20
    fileprivate let header: String = "Gifs"
    
    fileprivate var searchController: UISearchController!
    fileprivate var searchlabel: UILabel!
    fileprivate let searchDefault: String = "Trending"
    
    fileprivate var gifs: [Gif] = []
    var layout: CHTCollectionViewWaterfallLayout!
    var collectionView: UICollectionView!
    var collectionViewQueue: DispatchQueue = DispatchQueue(label: "collectionViewQueue", attributes: [])
    var collectionViewUpdate: Bool = true
    
    // MARK: - load
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupNavButtons()
        setupCollectionLayout()
        setupCollectionView()
        setupSearchLabel()
        setupSearchController()
        toggleSearchBar()
        loadBatch()
    }
    
    deinit {
        print("Deinit")
    }
}

// MARK: - nav
extension GifsViewController {
    fileprivate func setupNav() {
        title = "Trending"
        navigationController?.hidesBarsOnSwipe = true
        view.backgroundColor = .white
    }
    
    fileprivate func setupNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(refresh))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
    }
    
    fileprivate dynamic func search() {
        toggleSearchBar()
    }
    
    fileprivate dynamic func refresh() {
        // TODO: terminate previous requests
        // TODO: only download those without data
        for gif in gifs {
            reloadCollection(indexPaths: [gif.indexPath as IndexPath])
            downloadSmallGif(gif: gif)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }
}


// MARK: - search bar
extension GifsViewController: UISearchControllerDelegate, UISearchBarDelegate {
    fileprivate func setupSearchLabel() {
        searchlabel = UILabel()
        searchlabel.text = searchDefault
        searchlabel.font = UIFont.boldSystemFont(ofSize: 16.5)
        searchlabel.textAlignment = .center
        searchlabel.sizeToFit()
    }
    
    fileprivate func setupSearchController() {
        searchController = UISearchController(searchResultsController:  nil)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
    }
    
    fileprivate func toggleSearchBar(search: String?=nil) {
        searchlabel.text = search?.characters.count == 0 ? searchDefault : search ?? searchDefault
        searchController.searchBar.isHidden = !searchController.searchBar.isHidden
        if searchController.searchBar.isHidden {
            setupNavButtons()
            searchController.searchBar.text = ""
            searchController.searchBar.resignFirstResponder()
            navigationItem.titleView = searchlabel
        } else {
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
            navigationItem.titleView = searchController.searchBar
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleSearchBar()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        let trim = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        toggleSearchBar(search: trim)
    }
}



// MARK: - batch
extension GifsViewController {
    fileprivate func loadBatch() {
        for i in gifs.count..<gifs.count+batch {
            let indexPath: IndexPath = IndexPath(row: i, section: 0)
            let gif = Gif(indexPath: indexPath)
            
            insertCollection(data: [gif], indexPaths: [indexPath])
            downloadSmallGif(gif: gif)
        }
    }
}

// MARK: - download
extension GifsViewController {
    fileprivate func downloadSmallGif(gif: Gif) {
        gif.getSmall(
            sizeComplete: { [weak self] in
                self?.reloadCollection(indexPaths: [gif.indexPath as IndexPath])
            }, imageComplete: { [weak self] in
                self?.reloadCollection(indexPaths: [gif.indexPath as IndexPath])
            }, gifComplete: { [weak self] in
                self?.reloadCollection(indexPaths: [gif.indexPath as IndexPath])
            })
    }
    
    fileprivate func downloadLargeGif() {
        
    }
}

// MARK: - infinite scroll
extension GifsViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        let scrollBottom = scrollView.contentOffset.y + collectionView.frame.size.height
        let contentHeight = collectionView.contentSize.height
        let bottomTrigger = collectionView.frame.size.height/3
        if scrollBottom > contentHeight - bottomTrigger  {
            loadBatch()
        }
    }
}

// MARK: - collectionView update
extension GifsViewController {
    fileprivate func reloadCollection(indexPaths: [IndexPath]) {
        // calls willDisplayCell to update cell with data
        collectionView.performBatchUpdates({
            self.collectionView.reloadItems(at: indexPaths)
            }, completion: nil)
    }
    
    fileprivate  func insertCollection(data: [Gif], indexPaths: [IndexPath] ) {
        collectionView.performBatchUpdates({
            self.gifs += data
            self.collectionView.insertItems(at: indexPaths)
            }, completion: nil)
    }
}

// MARK: - collectionView pinterest
extension GifsViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = gifs[indexPath.row].imgSmallWidth ?? imageWidth
        let height = gifs[indexPath.row].imgSmallHeight ?? imageWidth
        
        return CGSize(width: width, height: height)
    }
    
    func setupCollectionLayout() {
        layout = CHTCollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        updateCollectionLayoutRows()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) -> Void in
            let orient = UIApplication.shared.statusBarOrientation
            switch orient {
            case .portrait: break
            default: break
            }
            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
                self.updateCollectionLayoutRows()
        })
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    fileprivate func updateCollectionLayoutRows() {
        layout.columnCount = Int(view.frame.size.width/imageWidth)
    }
}

// MARK: - collectionView handler
extension GifsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.alwaysBounceVertical = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GifsViewControllerCell.self, forCellWithReuseIdentifier: GifsViewControllerCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GifsViewControllerCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // update cell
        guard let cell = cell as? GifsViewControllerCell else { return }
        cell.loadData(data: gifs[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = gifs[indexPath.row]
        if gif.state == .error {
            // retry downloading
            downloadSmallGif(gif: gif)
            reloadCollection(indexPaths: [indexPath])
        } else {
            // TODO: open large
            print("open")
            let modal = GifsModal()
            modal.show(controller: navigationController!, dismissible: true)
            
        }
    }
}
