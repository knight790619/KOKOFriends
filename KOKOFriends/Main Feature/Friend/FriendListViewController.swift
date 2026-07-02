//
//  FriendListViewController.swift
//  KOKOFriends
//
//  Created by Felix Chin on 2026/6/29.
//

import UIKit

class FriendListViewController: UIViewController {
    
    // MARK: - Enum
    
    enum FriendListViewType {
        /// 無好友
        case noFriend
        /// 只有好友列表
        case normalFriend
        /// 好友列表含邀請
        case friendWithInvite
    }
    
    enum FoldState {
        case fold
        case unfold
        
        mutating func toggle() {
            switch self {
            case .fold:
                self = .unfold
            case .unfold:
                self = .fold
            }
        }
    }
    
    // MARK: - @IBOutlet
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var topStackView: UIStackView!
    // Profile
    @IBOutlet private weak var profileSectionView: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var idLabel: UILabel!
    @IBOutlet private weak var idDotView: UIView!
    @IBOutlet private weak var headImageView: UIImageView!
    // Tab
    @IBOutlet private weak var tabSectionView: UIView!
    @IBOutlet private weak var friendBadgeCountView: UIView!
    @IBOutlet private weak var friendBadgeCountLabel: UILabel!
    @IBOutlet private weak var friendButton: UIButton!
    @IBOutlet private weak var chatBadgeCountView: UIView!
    @IBOutlet private weak var chatBadgeCountLabel: UILabel!
    @IBOutlet private weak var chatButton: UIButton!
    @IBOutlet private weak var tabUnderLine: UIView!
    // Search
    @IBOutlet private weak var searchSectionView: UIView!
    @IBOutlet private weak var searchView: UIView!
    @IBOutlet private weak var searchField: UITextField!
    // FriendList
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Private Properties
    
    private lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private var viewModel = FriendListViewModel()
    private var inviteSectionFoldState: FoldState = .fold
    private var inviteSectionViews: [InviteSectionView] = []
    
    private let viewType = PageState.shared.state
    private var isSearching = false
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBarButtonItems()
        configureLayout()
        
        bindViewModel()
        fetchData()
    }
    
}

// MARK: - @IBAction

private extension FriendListViewController {
    
    @IBAction func didClickIDButton(_ sender: Any) {
    }
    
    @IBAction func didClickHeadImageButton(_ sender: Any) {
    }
    
    @IBAction func didClickTabButton(_ sender: UIButton) {
    }
    
    @IBAction func didClickAddFriendButton(_ sender: Any) {
    }
    
}

// MARK: - NavigationBar ButtonItem

private extension FriendListViewController {
    
    func configureBarButtonItems() {
        // Left Button Item
        let withdrawButtonItem = UIBarButtonItem(image: UIImage(resource: .icNavPinkWithdraw), style: .plain, target: self, action: #selector(logout))
        let transferButtonItem = UIBarButtonItem(image: UIImage(resource: .icNavPinkTransfer), style: .plain, target: self, action: #selector(logout))
        navigationItem.setLeftBarButtonItems([withdrawButtonItem, transferButtonItem], animated: true)
        
        // Right Button Item
        let scanButtonItem = UIBarButtonItem(image: UIImage(resource: .icNavPinkScan), style: .plain, target: self, action: #selector(logout))
        navigationItem.setRightBarButtonItems([scanButtonItem], animated: true)
    }
    
    @objc func logout() {
        if let sceneDelegate = view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.switchToLoginView(animated: true)
        }
    }
    
}

// MARK: - ViewModel

private extension FriendListViewController {
    
    func bindViewModel() {
        viewModel.onLoading = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.showLoading()
        }
        viewModel.onSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.updateUI()
        }
        viewModel.onError = { [weak self] message in
            guard let strongSelf = self else { return }
            strongSelf.showError(message)
        }
        
        viewModel.onRefreshSuccess = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.refreshControl.endRefreshing()
            strongSelf.updateRefreshUI()
        }
        
        viewModel.onRefreshError = { [weak self] message in
            guard let strongSelf = self else { return }
            strongSelf.refreshControl.endRefreshing()
            strongSelf.showError(message)
        }
    }
    
    func fetchData() {
        viewModel.loadData(viewType: viewType)
    }
    
    @objc private func refresh() {
        viewModel.refreshData(viewType: viewType)
    }
    
    func showLoading() {
        print("開始載入資料")
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        
        present(alert, animated: true)
    }
    
}

// MARK: - Configure

private extension FriendListViewController {
    
    func configureLayout() {
        addTapGestureForCloseKeyboard(target: scrollView)
        
        idDotView.layer.cornerRadius = idDotView.frame.height / 2
        headImageView.layer.cornerRadius = headImageView.frame.height / 2
        
        friendBadgeCountView.layer.cornerRadius = friendBadgeCountView.frame.height / 2
        chatBadgeCountView.layer.cornerRadius = chatBadgeCountView.frame.height / 2
        tabUnderLine.layer.cornerRadius = 2
        
        chatBadgeCountLabel.text = "99+" // 固定顯示 99+
        
        configureSearchSection()
        
        switch viewType {
        case .noFriend:
            tableView.isHidden = true
        default:
            tableView.isHidden = false
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.refreshControl = refreshControl
            tableView.register(UINib(nibName: FriendTableViewCell.nibName, bundle: nil),
                               forCellReuseIdentifier: FriendTableViewCell.identifier)
        }
    }
    
    func configureProfileSection() {
        guard let user = viewModel.user else { return }
        
        nameLabel.text = user.name
        
        let emptyText = "設定 KOKO ID"
        
        switch viewType {
        case .noFriend:
            idLabel.text = emptyText
            idDotView.isHidden = false
        default:
            let prefixText = "KOKO ID："
            let kokoid = user.kokoid.isEmpty ? emptyText : prefixText + user.kokoid
            idLabel.text = kokoid
            idDotView.isHidden = !user.kokoid.isEmpty // 無設定 ID 時提示用戶
        }
    }
    
    func configureInviteSection(isRefresh: Bool) {
        guard viewType == .friendWithInvite else { return }
        
        let inviteFriends = viewModel.inviteFriends
        
        if inviteFriends.isEmpty {
            return
        } else {
            if isRefresh {
                inviteSectionFoldState = .fold // 刷新時一率顯示折疊
                // 移除全部的 view 重新添加
                inviteSectionViews.forEach({ view in
                    topStackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                })
                inviteSectionViews.removeAll()
            }
            guard let inviteFriend = inviteFriends.first else { return }
            let inviteSectionView: InviteSectionView = InviteSectionView.instanciateFromNib()
            inviteSectionView.delegate = self
            inviteSectionView.configureUI(name: inviteFriend.name, isFirst: true, inviteSectionFoldState: inviteSectionFoldState)
            inviteSectionViews.append(inviteSectionView)
            topStackView.insertArrangedSubview(inviteSectionView, at: 1) // index 0 是 ProfileView 所以從 1 開始
        }
    }
    
    func configureTabSection() {
        switch viewType {
        case .noFriend:
            friendBadgeCountView.isHidden = true
            chatBadgeCountView.isHidden = true
            
            let emptyView = EmptyView.instanciateFromNib()
            topStackView.addArrangedSubview(emptyView)
        default:
            chatBadgeCountView.isHidden = false
            
            let invitingFriendsCount = viewModel.invitingFriendsCount
            friendBadgeCountView.isHidden = invitingFriendsCount == 0
            friendBadgeCountLabel.text = "\(invitingFriendsCount)"
        }
    }
    
    func configureSearchSection() {
        switch viewType {
        case .noFriend:
            searchSectionView.isHidden = true
        default:
            searchField.delegate = self
            searchSectionView.isHidden = false
        }
    }
    
    func configureFriendList() {
        tableView.reloadData()
    }
    
    func updateUI() {
        configureProfileSection()
        configureInviteSection(isRefresh: false)
        configureTabSection()
        configureFriendList()
    }
    
    func updateRefreshUI() {
        configureInviteSection(isRefresh: true)
        configureTabSection()
        configureSearchSection()
    }
    
}

// MARK: - InviteSectionViewDelegate

extension FriendListViewController: InviteSectionViewDelegate {
    
    func didClickItemView() {
        // 只有一則 不處理收合
        if viewModel.inviteFriends.count <= 1 { return }
        
        // 更新折疊狀態
        inviteSectionFoldState.toggle()
        
        // 更新 UI
        updateInviteSectionViews()
    }
    
    func updateInviteSectionViews() {
        let inviteFriends = viewModel.inviteFriends
        
        // 第一個 view 每次都要更新 UI
        if let firstView = inviteSectionViews.first {
            firstView.updateUI(inviteSectionFoldState: inviteSectionFoldState)
        }
        
        switch inviteSectionFoldState {
        case .fold:
            // 保留第一個 view，其餘刪除
            while inviteSectionViews.count > 1 {
                let removedView = inviteSectionViews.removeLast()
                removedView.removeFromSuperview()
            }
        case .unfold:
            // 已經展開就不要重複加
            guard inviteSectionViews.count == 1 else { return }
            guard inviteFriends.count > 1 else { return }
            
            for index in inviteFriends.indices.dropFirst() {
                let inviteFriend = inviteFriends[index]
                
                let inviteSectionView: InviteSectionView = InviteSectionView.instanciateFromNib()
                inviteSectionView.configureUI(name: inviteFriend.name, isFirst: false, inviteSectionFoldState: inviteSectionFoldState)
                
                inviteSectionViews.append(inviteSectionView)
                topStackView.insertArrangedSubview(inviteSectionView, at: index + 1)
            }
        }
    }
    
    func didClickCheckButton() {
        print("點擊確認")
    }
    
    func didClickCancelButton() {
        print("點擊取消")
    }
    
}

// MARK: - UITextFieldDelegate

extension FriendListViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        updateSearchModeUI(isHidden: true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        updateSearchModeUI(isHidden: false)
        return true
    }
    
    func updateSearchModeUI(isHidden: Bool) {
        profileSectionView.isHidden = isHidden
        tabSectionView.isHidden = isHidden
        
        if viewType == .friendWithInvite {
            inviteSectionViews.forEach({ inviteView in
                guard topStackView.arrangedSubviews.contains(inviteView) else { return }
                
                inviteView.isHidden = isHidden
            })
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let textRange = Range(range, in: currentText) else { return true }

        let updatedText = currentText.replacingCharacters(in: textRange, with: string)
        let keyword = updatedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if keyword.isEmpty {
            isSearching = false
        } else {
            viewModel.search(keyword: keyword)
            isSearching = true
        }
        
        tableView.reloadData()
        
        return true
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? viewModel.filteredFriends.count : viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.identifier, for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        
        let friend = isSearching ? viewModel.filteredFriends[indexPath.row] : viewModel.friends[indexPath.row]
        cell.configureUI(friend: friend)
        
        return cell
    }
    
}

// MARK: - Keyboard.

private extension FriendListViewController {
    
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    /// 點擊畫面關閉鍵盤
    func addTapGestureForCloseKeyboard(target view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
}
