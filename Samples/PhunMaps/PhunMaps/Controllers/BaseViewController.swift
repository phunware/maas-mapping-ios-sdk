//
//  BaseViewController.swift
//  Mapping-Sample
//
//  Created on 6/16/17.
//  Copyright © 2017 Phunware. All rights reserved.
//

import UIKit
import PWMapKit

let mapPOITypeSelectionSegue = "MapPOITypeSelection"

protocol SegmentedViewController {
    
    var toolbar: ToolbarView! { get set }
    
    func segmentedViewWillAppear()
    func segmentedViewWillDisappear()
}

class BaseViewController: UIViewController {
    
    @IBOutlet weak var segementedContainerView: UIView!
    @IBOutlet weak var segmentedContainerViewHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let segmentedContainerDefaultHeight: CGFloat = 63
    
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var directoryContainerView: UIView!
    @IBOutlet weak var aroundMeContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    
    weak var mapViewController: MapViewController!
    weak var directoryViewController: DirectoryViewController!
    weak var aroundMeViewController: AroundMeViewController!
    weak var listViewController: RouteListViewController!
    
    @IBOutlet weak var toolbar: ToolbarView!
    
    var searchTextField: UITextField!
    var searchtextFieldLeadingConstraint: NSLayoutConstraint!
    let defaultSearchTextFieldLeading: CGFloat = 10.0
    let defaultMapSearchTextFieldLeading: CGFloat = 50.0
    var cancelButton: UIBarButtonItem!
    var navRouteButton: UIBarButtonItem!
    
    let routeSegueIdentifier = "RouteViewController"
    
    enum segments: String {
        case map = "Map"
        case directory = "Directory"
        case aroundMe = "Around Me"
        case list = "List"
        
        func localizedString() -> String {
            return NSLocalizedString(self.rawValue, comment: "")
        }
    }
    
    let mainSegments: [segments] = [.map, .directory, .aroundMe]
    let routingSegments: [segments] = [.map, .list]
    var currentSegments: [segments]! {
        didSet {
            segmentedControl.removeAllSegments()
            for index in 0..<currentSegments.count {
                segmentedControl.insertSegment(withTitle: currentSegments[index].localizedString(), at: index, animated: false)
            }
        }
    }
    var selectedSegmentBeforeRouting: segments!
    var containerViews: [UIView]!
    
    var currentSegmentedController: SegmentedViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerViews = [mapContainerView, directoryContainerView, aroundMeContainerView, listContainerView]
        configureSearchTextField()
        assignViewControllers()
        
        navRouteButton = UIBarButtonItem(image: UIImage(named: "PWDirectionBarButtonItemImage"), style: .plain, target: self, action: #selector(navigationButtonTapped))
        cancelButton = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        navigationController?.navigationBar.barTintColor = CommonSettings.navigationBarBackgroundColor
        navigationController?.navigationBar.tintColor = CommonSettings.navigationBarForegroundColor
        segementedContainerView.backgroundColor = CommonSettings.navigationBarBackgroundColor
        toolbar.barTintColor = CommonSettings.navigationBarBackgroundColor
        
        segmentedControl.addTarget(self, action: #selector(switchSegment(segmentedControl:animated:)), for: .valueChanged)
        segmentedControl.backgroundColor = CommonSettings.navigationBarBackgroundColor
        currentSegments = mainSegments
        
        segmentedControl.selectedSegmentIndex = currentSegments.index(of: .map) ?? 0
        switchSegment(segmentedControl: segmentedControl, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(startRoutingMode(notification:)), name: .startNavigatingRoute, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !routingMode() {
            searchTextField.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchTextField.isHidden = true
        searchTextField.endEditing(true)
        super.viewWillDisappear(animated)
    }
    
    func assignViewControllers() {
        for viewController in childViewControllers {
            if let viewController = viewController as? MapViewController {
                mapViewController = viewController
                mapViewController.toolbar = toolbar
            } else if let viewController = viewController as? DirectoryViewController {
                directoryViewController = viewController
                directoryViewController.mapView = mapViewController.mapView
                directoryViewController.toolbar = toolbar
            } else if let viewController = viewController as? AroundMeViewController {
                aroundMeViewController = viewController
                aroundMeViewController.mapView = mapViewController.mapView
                aroundMeViewController.toolbar = toolbar
            } else if let viewController = viewController as? RouteListViewController {
                listViewController = viewController
                listViewController.toolbar = toolbar
            }
        }
    }
    
    func switchSegment(segmentedControl: UISegmentedControl, animated: Bool = true) {
        currentSegmentedController?.segmentedViewWillDisappear()
        
        switch currentSegments[segmentedControl.selectedSegmentIndex] {
        case .map:
            mapViewController.segmentedViewWillAppear()
            currentSegmentedController = mapViewController
            if !routingMode() {
                setDefaultMapSearchState()
            }
            
            transitionToContainer(view: mapContainerView, animated: animated)
        case .directory:
            directoryViewController.segmentedViewWillAppear()
            currentSegmentedController = directoryViewController
            searchtextFieldLeadingConstraint.constant = defaultSearchTextFieldLeading
            navigationItem.leftBarButtonItem = nil
            setDefaultSearchState(searchFieldLeadingConstant: defaultSearchTextFieldLeading)
            
            transitionToContainer(view: directoryContainerView, animated: animated)
        case .aroundMe:
            aroundMeViewController.segmentedViewWillAppear()
            currentSegmentedController = aroundMeViewController
            searchtextFieldLeadingConstraint.constant = defaultSearchTextFieldLeading
            navigationItem.leftBarButtonItem = nil
            setDefaultSearchState(searchFieldLeadingConstant: defaultSearchTextFieldLeading)
            
            transitionToContainer(view: aroundMeContainerView, animated: animated)
        case .list:
            listViewController.segmentedViewWillAppear()
            currentSegmentedController = listViewController
            transitionToContainer(view: listContainerView, animated: animated)
        }
    }
    
    func transitionToContainer(view: UIView, animated: Bool = true) {
        let animationDuration = animated ? 0.25 : 0.0
        view.isHidden = false
        UIView.animate(withDuration: animationDuration, animations: { [weak self] in
            if let containerViews = self?.containerViews {
                for containerView in containerViews {
                    if containerView == view {
                        containerView.alpha = 1.0
                    } else {
                        containerView.alpha = 0.0
                    }
                }
            }
            }, completion: { [weak self] (finished) in
                if let containerViews = self?.containerViews {
                    for containerView in containerViews {
                        if containerView != view {
                            containerView.isHidden = true
                        }
                    }
                }
        })
    }
    
    func cancelButtonTapped() {
        if routingMode() {
            mapViewController.cancelRoute()
            
            let currentlySelectedSegment = currentSegments[segmentedControl.selectedSegmentIndex]
            currentSegments = mainSegments
            if let indexToSelect = currentSegments.index(of: selectedSegmentBeforeRouting), currentlySelectedSegment != .map {
                segmentedControl.selectedSegmentIndex = indexToSelect
            } else {
                segmentedControl.selectedSegmentIndex = currentSegments.index(of: .map) ?? 0
            }
            switchSegment(segmentedControl: segmentedControl)
            
            searchTextField.isHidden = false
        } else {
            cancelSearch()
        }
    }
    
    func cancelSearch() {
        setDefaultMapSearchState()
    }
    
    func navigationButtonTapped() {
        performSegue(withIdentifier: routeSegueIdentifier, sender: self)
    }
    
    func setDefaultMapSearchState() {
        mapViewController.mapDirectoryContainerView.isHidden = true
        setDefaultSearchState(searchFieldLeadingConstant: defaultMapSearchTextFieldLeading)
    }
    
    func setDefaultSearchState(searchFieldLeadingConstant: CGFloat) {
        segmentedContainerViewHeightContraint.constant = segmentedContainerDefaultHeight
        searchtextFieldLeadingConstraint.constant = searchFieldLeadingConstant
        navigationItem.leftBarButtonItem = navRouteButton
        searchTextField.endEditing(true)
    }
    
    func startRoutingMode(notification: Notification) {
        if let route = notification.object as? PWRoute {
            listViewController.route = route
        }
        selectedSegmentBeforeRouting = currentSegments[segmentedControl.selectedSegmentIndex]
        currentSegments = routingSegments
        let segmentToSelect = UIAccessibilityIsVoiceOverRunning() ? segments.list : segments.map
        segmentedControl.selectedSegmentIndex = currentSegments.index(of: segmentToSelect) ?? 0
        switchSegment(segmentedControl: segmentedControl)
        
        searchTextField.isHidden = true
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func routingMode() -> Bool {
        return currentSegments == routingSegments
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        
        if identifier == routeSegueIdentifier {
            if let navigationController = segue.destination as? UINavigationController, let routeViewController = navigationController.topViewController as? RouteViewController {
                routeViewController.mapView = mapViewController.mapView
            }
        }
    }
}

// MARK: - SearchTextField

extension BaseViewController: UITextFieldDelegate {
    
    func configureSearchTextField() {
        guard let navBar = navigationController?.navigationBar else {
            return
        }
        
        searchTextField = UITextField(frame: CGRect.zero)
        searchTextField.borderStyle = .roundedRect
        searchTextField.textAlignment = .center
        searchTextField.tintColor = CommonSettings.navigationBarBackgroundColor
        searchTextField.returnKeyType = .search
        searchTextField.clearButtonMode = .always
        searchTextField.placeholder = NSLocalizedString("Search for Point of Interest", comment: "")
        searchTextField.delegate = self
        navBar.addSubview(searchTextField)
        
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        navBar.addConstraint(NSLayoutConstraint(item: searchTextField, attribute: .top, relatedBy: .equal, toItem: navBar, attribute: .top, multiplier: 1.0, constant: 5))
        navBar.addConstraint(NSLayoutConstraint(item: searchTextField, attribute: .bottom, relatedBy: .equal, toItem: navBar, attribute: .bottom, multiplier: 1.0, constant: -5))
        navBar.addConstraint(NSLayoutConstraint(item: searchTextField, attribute: .trailing, relatedBy: .equal, toItem: navBar, attribute: .trailing, multiplier: 1.0, constant: -10))
        
        searchtextFieldLeadingConstraint = NSLayoutConstraint(item: searchTextField, attribute: .leading, relatedBy: .equal, toItem: navBar, attribute: .leading, multiplier: 1.0, constant: defaultSearchTextFieldLeading)
        navBar.addConstraint(searchtextFieldLeadingConstraint)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if mapContainerView.isHidden == false {
            segmentedContainerViewHeightContraint.constant = 0
            searchtextFieldLeadingConstraint.constant = 80
            navigationItem.leftBarButtonItem = cancelButton
            
            mapViewController.mapDirectoryContainerView.isHidden = false
            mapViewController.mapDirectoryViewController.search(keyword: searchTextField.text)
            mapViewController.mapDirectoryViewController.delegate = self
        } else {
            setDefaultSearchState(searchFieldLeadingConstant: defaultSearchTextFieldLeading)
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length > 0 {
            let text: NSString = textField.text != nil ? textField.text! as NSString : "" as NSString
            let searchText = text.substring(with: NSMakeRange(0, range.location))
            directoryViewController.searchKeyword = searchText
            mapViewController.mapDirectoryViewController.searchKeyword = searchText
            aroundMeViewController.searchKeyword = searchText
        } else {
            let text: NSString = textField.text != nil ? textField.text! as NSString : "" as NSString
            let searchText = text.appending(string)
            directoryViewController.searchKeyword = searchText
            mapViewController.mapDirectoryViewController.searchKeyword = searchText
            aroundMeViewController.searchKeyword = searchText
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        directoryViewController.searchKeyword = ""
        mapViewController.mapDirectoryViewController.searchKeyword = ""
        aroundMeViewController.searchKeyword = ""
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        directoryViewController.searchKeyword = textField.text
        mapViewController.mapDirectoryViewController.searchKeyword = textField.text
        aroundMeViewController.searchKeyword = textField.text
        textField.endEditing(true)
        return false
    }
}

// MARK: - Keyboard

extension BaseViewController {
    
    func keyboardWillHide() {
        directoryViewController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        aroundMeViewController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        mapViewController.mapDirectoryViewController.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsetsMake(0, 0, keyboardSize.size.height - toolbar.frame.height, 0)
            directoryViewController.tableView.contentInset = insets
            aroundMeViewController.tableView.contentInset = insets
            mapViewController.mapDirectoryViewController.tableView.contentInset = insets
        }
    }
}

// MARK: - DirectoryViewControllerDelegate

extension BaseViewController: DirectoryViewControllerDelegate {
    
    func didSelectPOI(selectedPOI: PWPointOfInterest) {
        cancelSearch()
        if selectedPOI.floorID != mapViewController.mapView.currentFloor.floorID {
            mapViewController.mapView.currentFloor = mapViewController.mapView.building.floor(byId: selectedPOI.floorID)
        }
        mapViewController.mapView.setCenter(selectedPOI.coordinate, animated: true)
    }
}

