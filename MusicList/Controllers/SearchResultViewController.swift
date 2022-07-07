//
//  SearchResultViewController.swift
//  MusicList
//
//  Created by 정호윤 on 2022/07/06.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    // 네트워크 매니저 (싱글톤)
    private let networkManager = NetworkManager.shared
    
    // (음악 데이터를 다루기 위함) 빈배열로 시작
    private var musicArrays: [Music] = []
    
    // 컬렉션 뷰
    private lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
    
    // 컬렉션 뷰의 레이아웃을 담당하는 객체
    private let flowLayout = UICollectionViewFlowLayout()
    
    // 서치 바에서 검색 단어를 담는 변수(이전 화면에서 전달받음)
    var searchTerm: String? {
        didSet {
            setDatas()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setCollectionView()
        setCollectionViewConstraints()
        
        setDatas()

    }

    // 컬렉션 뷰 세팅
    private func setCollectionView() {
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        
        // ⭐️ 타입 인스턴스로(메타타입) 셀 등록
        collectionView.register(MusicCollectionViewCell.self, forCellWithReuseIdentifier: Cell.musicCollectionViewCellIdentifier)
        
        // 컬렉션뷰의 스크롤 방향 설정
        flowLayout.scrollDirection = .vertical
        
        // 아이템 사이즈 구하기
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns

        // 아이템 사이즈
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth)
        
        // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh
        
        // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
        
        // 컬렉션뷰의 속성에 할당
        collectionView.collectionViewLayout = flowLayout
    }
    
    private func setCollectionViewConstraints() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // 데이터 세팅
    private func setDatas() {
        // 옵셔널 바인딩
        guard let term = searchTerm else { return }
        print("네트워킹 시작 단어 \(term)")
        
        // 네트워킹 시작전에 다시 빈배열로 만들기
        self.musicArrays = []
        
        // 네트워킹 시작 (찾고자하는 단어를 가지고)
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicDatas):
                // 결과를 배열에 담고
                self.musicArrays = musicDatas
                // 컬렉션 뷰를 리로드 (메인쓰레드에서)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

extension SearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCellIdentifier, for: indexPath) as! MusicCollectionViewCell
        cell.imageUrl = musicArrays[indexPath.item].imageUrl
        return cell
    }
    
}
