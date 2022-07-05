//
//  NetworkingManager.swift
//  MusicList
//
//  Created by 정호윤 on 2022/07/05.
//

import Foundation

// MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

// MARK: - 네트워킹 클래스 모델
final class NetworkManager {
    
    // 여러 화면에서 통신하면 일반적으로 싱글톤으로 구현
    static let shared = NetworkManager()

    // 여러 객체를 추가적으로 생성하지 못하도록 설정
    private init() {}
    
    // Result 타입 너무 길어서 typealias 설정
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void

    // 네트워킹 요청하는 함수 - (Constants.swift 파일에 문자열 public enum으로 따로 정의)
    // 뷰컨에서 사용해야하기 때문에 private으로 선언 X
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        // print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
        
    }
    
    // 실제 request 하는 함수(비동기적 실행: 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlString: String, completion: @escaping NetworkCompletion) {
        // print(#function)

        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            // 에러 먼저 확인
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            // 데이터 확인
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            // 메서드 실행해서, 결과를 받음
            if let musics = self.parseJSON(safeData) {
                print("Parse 실행")
                completion(.success(musics))
            } else {
                print("Parse 실패")
                completion(.failure(.parseError))
            }
        }
        
        // task 시작해줘야함
        task.resume()
    }
    
    // 받은 데이터 분석하는 함수(동기적 실행)
    private func parseJSON(_ musicData: Data) -> [Music]? {
        //print(#function)
    
        // 성공
        do {
            // 우리가 만들어 놓은 모델로 변환하는 객체와 메서드
            // (JSON 데이터 -> MusicData 구조체)
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        // 실패
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
