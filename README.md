# infra-workshop

## Subway-Map

### 망 구성하기

> ***"VPC 구성"***

> [!TIP]
> CIDR은 C class(x.x.x.x/24)로 생성 (현업에선 가급적 B class로 생성하기 😀)
> | 클래스 | IP 할당 범위 | 사용 가능한 IP 개 수 | 예시
> | --- | --- | --- | --- | 
> | B Class | 128.0.0.0 ~ 191.0.0.0 | 2^16 (65,536) | 128.12.12.12 |
> | C Class | 192.0.0.0 ~ 223.0.0.0 | 2^8 (256) | 192.168.10.1 |

> [!NOTE]
> **VPC**
> - NAME: infraworkshop-apne2
> - CIDR_BLOCK: 192.168.10.0/24

> ***"서브넷 구성"***

> [!NOTE]
> - 외부망으로 사용할 Subnet : 64개씩 2개 (AZ를 다르게 구성)
>   - 외부망은 인터넷 구간과 통신 가능
> - 내부망으로 사용할 Subnet : 32개씩 1개
>   - 내부망에서만 인터넷 접근 가능
> - 관리용으로 사용할 Subnet : 32개씩 1개 (system manager를 사용한다면 별도의 관리망 없이 내부망 2개로 구성, 보안그룹도 상황에 맞게 구성)

| 용도 | 이름 | CIDR | AZ |
| --- | --- | --- | --- | 
| 외부 | infraworkshop-apne2-public-subnet-a | 192.168.10.0/26 | ap-northeast-2a |
| 외부 | infraworkshop-apne2-public-subnet-c | 192.168.10.64/26 | ap-northeast-2c |
| 내부 | infraworkshop-apne2-private-subnet-a | 192.168.10.128/27 | ap-northeast-2a |
| 관리 | infraworkshop-apne2-private-subnet-c | 192.168.10.160/27 | ap-northeast-2c |


> ***"인터넷 게이트웨이 구성"***

> [!NOTE]
> 인터넷 게이트웨이는 퍼블릭 IP 주소를 지닌 인스턴스를 인터넷과 연결하면 인터넷에서 들어오는 요청을 수신할 수 있도록 한다.

| 용도 | 이름 | 도착지 | VPC |
| --- | --- | --- | --- | 
| 외부 | infraworkshop-apne2-igw | 0.0.0.0 | ap-northeast-2a |


> ***"나트 인스턴스 구성"***




> ***"라우트 테이블 구성"***
| 용도 | 이름 | 서브넷 연결 | 게이트웨이 |
| --- | --- | --- | --- |
| 외부 | infraworkshop-apne2-public-route-table | infraworkshop-apne2-public-subnet-a, infraworkshop-apne2-public-subnet-c | ap-northeast-2a |
| 내부 | infraworkshop-apne2-private-route-table | 192.168.10.64/26 | ap-northeast-2c |