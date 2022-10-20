//
//  RepositoryListVC.swift
//  GitHubRepository_FC
//
//  Created by YoonDaesung on 2022/10/18.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

class RepositoryListVC: UITableViewController {
	
	private let organization = "Apple"
	private let repositories = BehaviorSubject<[Repository]>(value: [])
	private let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		title = organization + "Repositories"
		
		self.refreshControl = UIRefreshControl()
		let refreshControl = self.refreshControl!
		refreshControl.tintColor = .darkGray
		refreshControl.attributedTitle = NSAttributedString(string: "당겨서 새로고침")
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		
		tableView.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
		tableView.rowHeight = 140
	}
	
	@objc func refresh() {
		
	}
	
	func fetchRepositories(of organization: String) {
		Observable.from([organization])
			.map { organization -> URL in
				return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
			}
			.map { url -> URLRequest in
				var request = URLRequest(url: url)
				request.httpMethod = "GET"
				return request
			}
			.flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
				return URLSession.shared.rx.response(request: request)
			}
			.filter { response, _ in
				return 200..<300 ~= responds.statusCode
			}
			.map { _, data -> [[String: Any]] in
				guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
							let result = json as? [[String: Any]] else {
					return []
				}
				return result
			}
			.filter { result in
				return result.count > 0
			}
			.map { objects in
				return objects.compactMap { dic -> Repository? in
					guard let id = dic["id"] as? Int,
								let name = dic["name"] as? String,
								let description = dic["description"] as? String,
								let stargazersCount = dic["stargazers_count"],
								let language = dic["language"] as? String else {
						return nil
					}
								
				}
			}
	}
}

// UITableView DataSource Delegate
extension RepositoryListVC {
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 0
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as?
						RepositoryListCell else { return UITableViewCell() }
		
		return cell
	}
}
