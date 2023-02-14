# Check It !

> **동아리 출석 관리 앱, Check It !**
<br/>

앱스토어 이미지 들어갈 자리 (수정예정)

<br/>

## 앱 소개

### ＞ ADS

```
사용자가 가입한 동아리의 출석체크를 도와주는 앱 입니다.
```

### ＞ 페르소나

```
오프라인 동아리 모임을 갖는 사람들
```

### ＞ 개발 목표

```
이 앱을 개발하게 된 동기와 목표 (수정예정)
```

<br/>

## 목차

1. [앱 소개](#앱-소개)
2. [주요 기능과 구동 화면-](#주요기능과-구현-화면)
3. [사용자 흐름도 및 아키텍쳐](#사용자-흐름도-및-아키텍쳐)
4. [개발 환경](#개발-환경)
5. [기술 스택](#기술-스택)
6. [참여자](#참여자)
7. [라이센스](#라이센스)

<br/>

## 주요 기능과 구현 영상 (수정예정)

|<img src=""></img>|<img src=""></img>|<img src=""></img>|
|:-:|:-:|:-:|
|`Splash screen`|`Onboarding`|`Login`|

<br>

### 버튼 하나로 간편하게 출석하기
> 사용자는 위치 기반 출첵 서비스, 길찾기, QR code 등, 다양한 방법으로 출석할 수 있어요!  
>**약속된 일정 Check It! ➔ 반경 50m 이내 출석하기 버튼 활성화 ➔ 출석 완료 알림**
- 방장 - 구성원 출석 시 Toast Message
- 구성원 - 출석 시 Lottie Message

|<img src=""></img>|<img src=""></img>|<img src=""></img>|
|:-:|:-:|:-:|
|`MapView`|`QR code`|`Calendar View`|

<br/>

### 동아리 더 쉽고 효율적으로 관리하기
> 방장과 운영진 및 구성원 각자에게 보여지는 뷰가 달라서 디테일하게 출석부를 관리할 수 있어요!  
>**동아리 생성 ➔ 초대 코드 공유로 가입 ➔ 일정 추가 및 수정 ➔ 출석부 관리**

|<img src=""></img>|<img src=""></img>|<img src=""></img>|
|:-:|:-:|:-:|
|`방장`|`운영진`|`구성원`|

<br/>

## 사용자 흐름도 및 아키텍쳐
|<img src="https://user-images.githubusercontent.com/114602459/218664674-71695d53-bc57-4502-b29f-623f1613ac05.png" width="500"></img>|<img src="https://user-images.githubusercontent.com/114602459/218670095-ef797fff-a1e2-4445-85e3-b0def6bbacbb.png" width="500"></img>|<img src="https://user-images.githubusercontent.com/114602459/218669916-fb598978-0029-4466-b97a-86805dc97333.png" width="500"></img>|
|:-:|:-:|:-:|
|`User Flow`|`UI, UX Design (Login && Check Tap)`|`UI, UX Design (Group Tap)`|

<br/>

## 개발 환경

- Xcode Version 14.2
- SwiftUI, iOS 15.0
- Auto layoout
- Dark mode, Horizontal mode not supported

<br/>

## 기술 스택

#### Platforms

<img src="https://img.shields.io/badge/iOS-000000?style=flat&logo=Apple&logoColor=white"/> 

#### Language & Tools

<img src="https://img.shields.io/badge/Swift-dd2c00?style=flat&logo=swift&logoColor=white"/> <img src="https://img.shields.io/badge/SwiftUI-0D0D0D?style=flat&logo=swift&logoColor=blue"/> <img src="https://img.shields.io/badge/Xcode-00b0ff?style=flat&logo=Xcode&logoColor=white"/>
<img src="https://img.shields.io/badge/Firebase-ff6d00?style=flat&logo=Firebase&logoColor=white"/> <img src="https://img.shields.io/badge/Figma-ff4081?style=flat&logo=Figma&logoColor=white"/>

#### SNS Login

<img src="https://img.shields.io/badge/kakaotalk-ffcd00?style=flat&logo=kakaotalk&logoColor=000000"/> <img src="https://img.shields.io/badge/Naver-00C300?style=flat&logo=naver&logoColor=white"/>
<img src="https://img.shields.io/badge/Google-0288d1?style=flat&logo=Google&logoColor=white"/>

<br/>


## 참여자

|허혜민<br/>[@soletree](https://github.com/soletree)|류창휘<br/>[@ryuchanghwi](https://github.com/ryuchanghwi)|윤예린<br/>[@blaire-pi](https://github.com/blaire-pi)|이학진<br/>[@LEEHAKJIN-VV](https://github.com/LEEHAKJIN-VV)|조현호<br/>[@HHCHO0220](https://github.com/HHCHO0220)|황예리<br/>[@hwangyeri](https://github.com/hwangyeri)|
|:-:|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/97100404?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/78063938?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/56533266?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/52197436?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/109830398?v=4" width=150>|<img src="https://avatars.githubusercontent.com/u/114602459?v=4" width=150>

<br/>

## 라이센스

```
Alamofire
- https://github.com/Alamofire/Alamofire

SDWebImage
- https://github.com/SDWebImage/SDWebImage

SwiftyJSON
- https://github.com/SwiftyJSON/SwiftyJSON

Kakao Login SDK for iOS
- https://developers.kakao.com/docs/latest/ko/kakaologin/ios

Firebase Apple Open Source Development
- https://github.com/firebase/firebase-ios-sdk
                
FirebaseUI
- https://github.com/firebase/FirebaseUI-iOS
                
AlertToast
- https://github.com/elai950/AlertToast
```

<br/>
