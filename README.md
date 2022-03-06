# VocaHelper

# Overview

- 단어장 만들기  
- 단어장 저장/불러오기    
- 문제풀기 연습  
- 문제풀기  
- 문제풀이 결과 및 최근 10번 성적 그래프로 확인  
- 저장한 단어 검색    
- 회원가입    
- 서버에 올라간 단어장 보기    
- 단어장 서버에 올리기  
- 업로드한 단어장 보기  
- 단어장 추천하기  
- 서버에 올라간 단어장 다운받기    
- 서버의 단어장 목록 정렬하기  
- 다크모드 지원  

---

# Skill

- Swift, UIKit, Code-Based UI, Autolayout
- RxSwift, RxCocoa, RxDatasources
- Firebase Auth, Firebase Firestore, Codable, FileManager

---

# Issues

- <details>
    <summary>Pagination 구현하기</summary>
    <div markdown="1">

    ```swift
    viewModel.webDataSubject            
        .bind(to: wordsTableView.rx.items(cellIdentifier: WebTableViewCell.identifier, cellType: WebTableViewCell.self)) { [weak self] indexPath, item, cell in
            // ...
            if self?.isStarting == true && indexPath == (self?.loadLimit ?? 5) - 1 {
                self?.isStarting = false
            }
            else if self?.isStarting == false && indexPath == (self?.loadLimit ?? 5) - 1 {
                self?.isStarting = true
                self?.loadLimit += 5
                self?.viewModel.makeWebDataSubject(
                    orderBy: self?.orderBy ?? "date",
                    loadLimit: self?.loadLimit ?? 5,
                    indiciator: self?.activityIndicator ?? UIActivityIndicatorView())
            }
        }.disposed(by: disposeBag)
    ```

    - Cell 생성시 데이터 로딩이 시작인지와 로드할 단어장의 수를 이용해 Pagination 구현
    - 마지막 셀이 첫 로딩인지 확인, 로딩 개수 5개
    - 마지막 셀 로딩때 false로 변경, 현재 디스플레이에 마지막 셀 없음
    - 스크롤해서 마지막 셀에 표시될 때 추가로드, 로딩 개수 5개씩 추가
    </div>
    </details>

- <details>
    <summary>단어장 목록에서 컬렉션뷰 아이템의 가로세로 비율 문제</summary>
    <div markdown="1">

    ```swift
    let width = view.bounds.width < view.bounds.height ?
    (view.bounds.width - 2*margin)/numberOfCell - margin/1.5 : 
    (view.bounds.height - 2*margin)/numberOfCell - margin/1.5
    ```

    - UICollectionViewFlowLayout에서 가로크기와 세로크기를 비교해서 해결
    - 가로길이가 더 크면 Landscape
    </div>
    </details>

- <details>
    <summary>landscape로 변경시 화면 비율이 달라져야 했음</summary>
    <div markdown="1">

    ```swift
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        stackViewHeightAnchor.isActive = false
        if size.width > size.height {
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.85)
            stackViewHeightAnchor.isActive = true
        }
        else {
            stackViewHeightAnchor = stackView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.65)
            stackViewHeightAnchor.isActive = true
        }
    }
    ```
    - viewWillTransition에서 가로 세로 길이를 비교해서 constant 조절
    </div>
    </details>

- <details>
    <summary>bordorColor 다크모드 대응</summary>
    <div markdown="1">

    ```swift
    extension UIColor {
        open class var whiteBlackDynamicColor: UIColor {            
            return UITraitCollection.current.userInterfaceStyle == .dark ? .white : .black
        }
        open class var blackWhiteDynamicColor: UIColor {            
            return UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
        }
        open class var grayBlackDynamicColor: UIColor {            
            return UITraitCollection.current.userInterfaceStyle == .dark ? .gray : .white
        }
    }  

    textfield.layer.borderColor = UIColor.whiteBlackDynamicColor.cgColor
    ```
    - borderColor는 cgColor이므로 systemBackgroundColor 등으로 다크모드 대응이 안된다.
    - UITraitCollection.current.userInterfaceStyle를 이용해 CGColor에 대한 다크모드 대응
    </div>
    </details>

- <details>
    <summary>단어장 제작의 자유도와 안정성</summary>
    <div markdown="1">

    - 사용자의 여러가지 예상되는 여러 행동들에 단어장을 저장하는 기능을 넣었다.  
    - 그랬더니 테이블뷰가 모션이 끊기는 등 오히려 사용자 경험이 좋지 않았다.   
    - 뒤로갈때 저장, EditingEnd일때 저장, 자유도를 줄이고 안정성을 선택했다. 

    </div>
    </details>

---
