# Conference Room


## 망 구성하기


> [!NOTE]
> ***VPC 구성***

| name | cidr |
| --- | --- |
| infraworkshop-apne2 | 192.168.10.0/24 |

<br></br>

> [!NOTE]
> ***서브넷 구성***
>
> - 외부망 1: front, member 모듈
> 
> - 외부망 2: conference, analysis 모듈
> 
> - 내부망 1: DB
> 
> - 내부망 2: RDS 서브넷 그룹 설정을 위한 내부망 추가
> 
> - 관리망 1: Bastion -> 나중에 Session Manager 으로 변경

| 용도 | 이름 | CIDR | AZ |
| --- | --- | --- | --- | 
| 외부 | infraworkshop-apne2-public-subnet-a | 192.168.10.0/26 | ap-northeast-2a |
| 외부 | infraworkshop-apne2-public-subnet-c | 192.168.10.64/26 | ap-northeast-2c |
| 내부 | infraworkshop-apne2-private-subnet-a | 192.168.10.128/27 | ap-northeast-2a |
| 내부 | infraworkshop-apne2-private-subnet-c | 192.168.10.160/27 | ap-northeast-2c |
| 관리 | infraworkshop-apne2-management-subnet-a | 192.168.10.192/27 | ap-northeast-2a |

<br></br>

> [!NOTE]
> ***보안 그룹 규칙 구성***
> - **외부망**
>   - 전체 대역 : 443 포트 오픈
>   - 관리망 : 22번 포트 오픈
> - **내부망**
>   - 외부망 : 3306 포트 오픈
>   - 관리망 : 22번 포트 오픈
> - **관리망**
>   - 자신의 로컬 PC 공인 IP : 22번 포트 오픈

| 용도 | 이름 | 인바운드 규칙 | 아웃바운드 규칙 |
| --- | --- | --- | --- | 
| 외부 | infraworkshop-apne2-external-permit-security-group | `"0.0.0.0:ICMP"`, `"0.0.0.0/0:443"`, `infraworkshop-apne2-admin-permit-security-group:22` | `"0.0.0.0/0":0` |
| 내부 | infraworkshop-apne2-internal-permit-security-group | `"0.0.0.0:ICMP"`, `infraworkshop-apne2-external-permit-security-group:3306`, `infraworkshop-apne2-admin-permit-security-group:22` | `"0.0.0.0/0":0` |
| 관리 | infraworkshop-apne2-admin-permit-security-group | `my local IP/32:22` | `"0.0.0.0/0":0` |

<br></br>

> [!NOTE]
> ***인터넷 게이트웨이 구성***
> 
> 인터넷 게이트웨이는 퍼블릭 IP 주소를 지닌 인스턴스를 인터넷과 연결하면 인터넷에서 들어오는 요청을 수신할 수 있도록 한다.

| 용도 | 이름 | 도착지 | VPC |
| --- | --- | --- | --- | 
| 외부 | infraworkshop-apne2-igw | 0.0.0.0 | infraworkshop-apne2 |

<br></br>


> [!NOTE]
> ***라우팅 테이블 구성***

| 용도 | 이름 | 서브넷 연결 | 게이트웨이 |
| --- | --- | --- | --- |
| 외부 | infraworkshop-apne2-public-route-table | infraworkshop-apne2-public-subnet-a, infraworkshop-apne2-public-subnet-c | infraworkshop-apne2-igw |

---

<br></br>

## 서버 구성하기


> [!NOTE]
> ***Bastion Host 구성***
> 
> - 관리자 개인 로컬 IP 32 bit만 SSH 접근할 수 있도록 허용
> - 로컬 키 파일 생성 및 ***0400*** 권한 부여

| 용도 | 이름 | 서브넷 연결 | 보안 그룹 | 스펙 | 운영체제 | keypair |
| --- | --- | --- | --- | --- | --- | --- |
| Bastion | infraworkshop-apne2-bastion | infraworkshop-apne2-management-subnet-a | infraworkshop-apne2-admin-permit-security-group | t3.micro | AamazonLinux 2023 | infraworkshop-apne2-keypair |

> [!NOTE]
> ***RDS 구성***
> 
> - 같은 VPC 내에서만 통신, 외부 통신 금지(INSIDE ZONE 분리)

| 용도 | 이름 | 서브넷 그룹 | 보안 그룹 | 스펙 | DB Engine | DB Version |
| --- | --- | --- | --- | --- | --- | --- |
| Database | conference | infraworkshop-apne2-private-subnet-a, infraworkshop-apne2-private-subnet-c | infraworkshop-apne2-internal-permit-security-group | t3.micro | MySQL | 8.4.6 |


> [!NOTE]
> ***WAS Instance 구성***
> 
> - 모든 대역폭의 Https 443 포트 접근 허용
> - 관리망 SSH 22 포트 접근 허용
> - Bastion Host와 로컬 키 파일 공용 사용

| 용도 | 이름 | 서브넷 연결 | 보안 그룹 | 스펙 | 운영체제 | keypair |
| --- | --- | --- | --- | --- | --- | --- |
| WAS-01 | infraworkshop-apne2-was-01 | infraworkshop-apne2-public-subnet-a | infraworkshop-apne2-external-permit-security-group | t3.medium | AamazonLinux 2023 | infraworkshop-apne2-keypair |
| WAS-02 | infraworkshop-apne2-was-02 | infraworkshop-apne2-public-subnet-c | infraworkshop-apne2-external-permit-security-group | t3.medium | AamazonLinux 2023 | infraworkshop-apne2-keypair |
