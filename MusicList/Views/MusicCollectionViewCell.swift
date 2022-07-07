//
//  MusicCollectionViewCell.swift
//  MusicList
//
//  Created by 정호윤 on 2022/07/06.
//

import UIKit

final class MusicCollectionViewCell: UICollectionViewCell {
    
    private var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        return imageView
    }()
    
    // 이미지 URL을 전달받는 속성
    var imageUrl: String? {
        didSet {
            loadImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImageViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImageViewConstraints() {
        self.addSubview(mainImageView)
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // URL -> 이미지를 세팅하는 메서드
    private func loadImage() {
        guard let urlString = imageUrl, let url = URL(string: urlString)  else { return }
        
        // 비동기 처리
        DispatchQueue.global().async {
            // URL을 가지고 데이터를 만드는 메서드 (오래걸리는데 동기적인 실행)
            guard let data = try? Data(contentsOf: url) else { return }
            
            // ⭐️ 오래걸리는 작업이 일어나고 있는 동안에 url이 바뀔 가능성 제거
            guard urlString == url.absoluteString else { return }
            
            // 작업의 결과물을 이미지로 표시(메인 큐)
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: data)
            }
        }
    }
    
    // 셀이 재사용되기 전에 호출되는 메서드
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // ⭐️ 일반적으로 이미지가 바뀌는 것처럼 보이는 현상을 없애기 위해서 실행
        self.mainImageView.image = nil
    }
    
}
