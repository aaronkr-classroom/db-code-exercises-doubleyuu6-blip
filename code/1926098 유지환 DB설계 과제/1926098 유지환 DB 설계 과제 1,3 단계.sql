__1단계 — 엔티티 & 속성
Member (회원): member_id, name, email, phone, join_date
Product (상품): product_id, name, price, stock, category


--3단계 - 객체관계 모델
MEMBER(member_id PK, name, email, phone, join_date)

PRODUCT(product_id PK, name, price, stock, category)

ORDER_ITEM(order_id PK, member_id FK → MEMBER, product_id FK → PRODUCT, quantity, order_date)

