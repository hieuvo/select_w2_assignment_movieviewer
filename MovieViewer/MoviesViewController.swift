//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

enum MoviesViewMode {
    
    case NowPlaying, TopRated
}

enum DisplayMode {
    case Grid, List
}

private let sectionInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)

class MoviesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var displayModeSegmented: UISegmentedControl!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    
    var refreshControl: UIRefreshControl!
    var refreshControlGrid: UIRefreshControl!
    var searchBar = UISearchBar()
    var defaultNavigationTitleView: UIView?
    
    var movies: [Movie]? {
        didSet {
            filteredMovies = movies
        }
    }
    
    var filteredMovies: [Movie]?
    var viewMode: MoviesViewMode = .NowPlaying
    var endPointUrl: String {
        switch viewMode {
        case .TopRated:
            return TMDBClient.MovieTopRated
        default:
            return TMDBClient.MovieNowPlaying
        }
    }
    var displayMode = DisplayMode.List
    
    var settings: [String: String] = [:]
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadMovies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerClass(MovieCell.self, forCellReuseIdentifier: "MovieCell")
        
        // set delegate
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        // setup controls, UI
        setupRefreshControls()
        setDisplayMode(displayMode)
        defaultNavigationTitleView = navigationItem.titleView
        setTheme()
    }
    
    func injected() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.injected()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var indexPath: NSIndexPath?
        
        if let cell = sender as? UITableViewCell {
            indexPath = tableView.indexPathForCell(cell)
        } else if let cell = sender as? UICollectionViewCell {
            indexPath = collectionView.indexPathForCell(cell)
        }
        
        let movie = filteredMovies![indexPath!.row]
        let movieDetailView = segue.destinationViewController as! MovieDetailViewController
        movieDetailView.movie = movie
    }
    
    @IBAction func onChangeDisplayMode(sender: AnyObject) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            setDisplayMode(.Grid)
        case 1:
            setDisplayMode(.List)
        default:
            setDisplayMode(.Grid)
        }
    }
    
    @IBAction func onTapSearchButton(sender: AnyObject) {
        if(searchBarButton.title == "Search") {
            searchBarButton.title = "Cancel"
            navigationItem.titleView = searchBar
            searchBar.becomeFirstResponder()
            let filtersButton = UIBarButtonItem(title: "Filters", style: .Plain, target: self, action: #selector(onFilters))
            
            navigationItem.rightBarButtonItems = [filtersButton, searchBarButton]
            
        } else {
            searchBarButton.title = "Search"
            searchBar.text = ""
            navigationItem.titleView = defaultNavigationTitleView
            filteredMovies = movies
            self.searchBar(searchBar, textDidChange: "")
            searchBar.resignFirstResponder()
            navigationItem.rightBarButtonItems = [searchBarButton]
        }
    }
    
    func onFilters(sender: UIBarButtonItem? = nil) {
        print("clicked filters button")
        let filtersVC: FiltersViewController = createFiltersVC()
        filtersVC.delegate = self
        self.navigationController?.pushViewController(filtersVC, animated: false)
    }
    
    func createFiltersVC() -> FiltersViewController {
        // make instance from xib file, but it doesn't support static cell
        // return FiltersViewController(nibName: "FiltersViewController", bundle: nil)
        
        // make instance from storyboard
        return FiltersViewController.instantiateFromStoryboard(UIStoryboard.mainStoryboard())
    }
    
    func hideError() {
        errorView.hidden = true
    }
    
    func showError(error: NSError) {
        errorLabel.text = error.localizedDescription
        errorView.hidden = false
    }
    
    func setupRefreshControls() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), forControlEvents: .ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        // remove showing empty row for table incase network error
        tableView.tableFooterView = UIView()
        
        refreshControlGrid = UIRefreshControl()
        refreshControlGrid.addTarget(self, action: #selector(onRefresh), forControlEvents: .ValueChanged)
        collectionView.insertSubview(refreshControlGrid, atIndex: 0)
        // this help show refresh control in case empty collection view
        self.collectionView!.alwaysBounceVertical = true
    }
    
    func onRefresh() {
        loadMovies()
    }
    
    func loadMovieComplete(movies: [Movie]?, error: NSError?) {
        MBProgressHUD.hideHUDForView(self.view, animated: true)
        endRefreshing()
        
        guard error == nil else {
            self.movies?.removeAll()
            reloadData()
            showError(error!)
            return
        }
        
        self.movies = movies
        reloadData()
    }
    
    func loadMovies() {
        hideError()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        if settings == [:] {
            TMDBClient.fetchMovies(endPointUrl, page: nil, language: nil, complete: loadMovieComplete)
        } else {
            TMDBClient.fetchMovies(settings, page: nil, language: nil, complete: loadMovieComplete)
        }   
    }
    
    func setDisplayMode(mode: DisplayMode) {
        displayMode = mode
        
        switch mode {
        case .Grid:
            collectionView.hidden = false
            tableView.hidden = true
        case .List:
            collectionView.hidden = true
            tableView.hidden = false
        }
        
        reloadData()
    }
    
    func endRefreshing() {
        self.refreshControl.endRefreshing()
        self.refreshControlGrid.endRefreshing()
    }
    
    func reloadData() {
        switch displayMode {
        case .Grid:
            collectionView.reloadData()
        case .List:
            tableView.reloadData()
        }
    }
    
    func setTheme() {
        tableView.backgroundColor = UIColor.blackColor()
        collectionView.backgroundColor = UIColor.blackColor()
        
        searchBar.tintColor = themeColor
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = themeColor
        searchBar.keyboardAppearance = .Dark
        
        refreshControl.backgroundColor = UIColor.blackColor()
        refreshControl.tintColor = themeColor
        
        refreshControlGrid.backgroundColor = UIColor.blackColor()
        refreshControlGrid.tintColor = themeColor
        
        errorView.backgroundColor = UIColor.whiteColor()
        errorView.alpha = 0.8
        errorLabel.textColor = UIColor.redColor()
    }
}

extension MoviesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = filteredMovies![indexPath.row]
        cell.setData(movie)
        
        return cell
    }
}

extension MoviesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let gridCell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        let movie = filteredMovies![indexPath.row]
        gridCell.setData(movie)
        gridCell.setTheme()
        
        return gridCell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 145, height: 200)
    }
    
    // Asks the delegate for the margins to apply to content in the specified section.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
}

extension MoviesViewController: UISearchBarDelegate {
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredMovies = searchText.isEmpty ? movies : movies!.filter({ (movie :Movie) -> Bool in
            return movie.title!.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension MoviesViewController: FiltersViewControllerDelegate {
    
    func updateSettings(vc: FiltersViewController, settings: [String: String]) {
        self.settings = settings
    }
    
    func inject(vc: FiltersViewController) {
        vc.dismissViewControllerAnimated(true, completion: nil)
        onFilters()
    }
}