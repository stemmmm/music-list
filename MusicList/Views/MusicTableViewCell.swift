//
//  MusicTableViewCell.swift
//  MusicList
//
//  Created by 정호윤 on 2022/07/06.
//

import UIKit

final class MusicTableViewCell: UITableViewCell {
    
    // 이미지 URL을 전달받는 속성
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    var music: Music? {
        didSet {
            guard let music = music else { return }
            songNameLabel.text = music.songName
            artistNameLabel.text = music.artistName
            albumNameLabel.text = music.albumName
            releaseDateLabel.text = music.releaseDate
        }
    }
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [songNameLabel, artistNameLabel, albumNameLabel, releaseDateLabel])
        stackView.axis = .vertical
        stackView.distribution  = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - 생성자 세팅
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        // 여기서 세팅함수 실행
        setStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 뷰, 스택 뷰로 구성된 셀
    private func setStackView() {
        // 셀 위에 뷰 올리기
        self.addSubview(mainImageView)
            
        // 셀 위에 스택 뷰 올리기
        self.addSubview(labelStackView)
    }
    
    // MARK: - 오토레이아웃 세팅
    // 오토레이아웃 업데이트하는 함수(뷰의 drawing cycle)
    override func updateConstraints() {
        setConstraints()
        // 주의: super를 나중에 호출
        super.updateConstraints()
    }
    
    private func setConstraints() {
        setMainImageViewConstraints()
        setLabelStackViewConstraints()
    }
    
    private func setMainImageViewConstraints() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 140),
            mainImageView.heightAnchor.constraint(equalToConstant: 140),
            mainImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
    }
    
    private func setLabelStackViewConstraints() {
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 20),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            labelStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            labelStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
    
    // URL -> 이미지를 세팅하는 메서드
    private func loadImage() {
        guard let urlString = self.imageUrl, let url = URL(string: urlString)  else { return }
        
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            // ⭐️ 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }

}
