//
//  ViewController.swift
//  MusicList
//
//  Created by 정호윤 on 2022/07/05.
//

import UIKit

final class ViewController: UIViewController {

    private let tableView = UITableView()
    
    var networkManager = NetworkManager.shared
    
    var musicArray: [Music] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavBar()
        setTableView()
        setTableViewConstraints()
        setDatas()
    }
    
    // 네비게이션 바 설정
    func setNavBar() {
        title = "노래 목록"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    // 테이블 뷰 설정
    func setTableView() {
        // 델리게이트 패턴의 대리자 설정
        tableView.dataSource = self
        tableView.delegate = self
        
        // ⭐️ 타입 인스턴스로(메타타입) 셀 등록
        tableView.register(MusicTableViewCell.self, forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    // 테이블 뷰의 오토레이아웃 설정
    func setTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    // 데이터 세팅
    func setDatas() {
        // 네트워킹의 시작
        networkManager.fetchMusic(searchTerm: "jazz") { result in
            // print(#function)
            switch result {
            case .success(let musicDatas):
                // 데이터를(배열) 받아오고 난 후
                self.musicArray = musicDatas
                // 테이블 뷰 리로드
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArray.count
    }
    
    // 셀의 구성(셀에 표시하고자 하는 데이터 표시)을 뷰컨트롤러에게 물어봄
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 힙에 올라간 재사용 가능한 셀을 꺼내서 사용하는 메서드
        // (사전에 셀을 등록하는 과정이 내부 메커니즘에 존재)
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicTableViewCell
        
        cell.imageUrl = musicArray[indexPath.row].imageUrl

        // ⭐️ 셀에다가 데이터만 전달하면 화면에 표시하도록 구현(didSet)
        cell.music = musicArray[indexPath.row]

        cell.selectionStyle = .none
        
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
}
