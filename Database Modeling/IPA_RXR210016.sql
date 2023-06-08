create database ipa3_raoji;
use ipa3_raoji;

CREATE TABLE CUSTOMERS_ADDRESS(
    Customer_address_ID VARCHAR(255) NOT NULL COMMENT 'PK',
    Address VARCHAR(500) COMMENT 'Address',
    State VARCHAR(255) COMMENT 'State',
    Zipcode INT COMMENT 'zipcode',
    Country VARCHAR(255) COMMENT 'Country'
);
alter table CUSTOMERS_ADDRESS
ADD constraint PK_Customer_address_ID PRIMARY KEY(Customer_address_ID);

CREATE TABLE CUSTOMER(  
    Customer_id VARCHAR(255) NOT NULL,
    Customer_name CHAR(255) COMMENT 'customer name',
    Customer_address_ID VARCHAR(255) NOT NULL COMMENT 'customer address ID',
    Mobile_No VARCHAR(255) COMMENT 'Mobile Number',
    Cust_Category INT COMMENT 'Category for discounts',
    Discount INT COMMENT 'Discount in %',
    Tax_ID VARCHAR(255) COMMENT 'Tax_ID',
    Accountant_contact VARCHAR(255) COMMENT 'Accountant contact'
);
alter table CUSTOMER
ADD constraint PK_Customer_ID PRIMARY KEY(Customer_ID);

alter table CUSTOMER
ADD constraint FK_Customer_address_ID1 foreign key(Customer_Address_ID) references CUSTOMERS_ADDRESS(Customer_address_ID);

insert into CUSTOMERS_ADDRESS values('A01','1300,West Cambell Road , Dallas , Texas','Texas',75241,'USA');
insert into CUSTOMERS_ADDRESS values('A02','906 W Georgebush Highway,apt 56,Richardson,Dallas','Texas',75254,'USA');
insert into CUSTOMERS_ADDRESS values('A03','458,Indian road ,Plano ,Texas','Texas',75267,'USA');
insert into CUSTOMERS_ADDRESS values('A04','415,Shadow glen drive,Little elm texas,Dallas','Texas',75280,'USA');
insert into CUSTOMERS_ADDRESS values('A05','905W Georgebush Highway ,apt 10212 Richardson,Dallas','Texas',75293,'USA');
insert into CUSTOMERS_ADDRESS values('A06','544 W , lovefield , Denton	Dallas','Texas',75306,'USA');
select * from customers_address;

insert into CUSTOMER values('1234',	'RAO','A01','4699271927',1,5,'AA11','4879456789');
insert into CUSTOMER values('3456','PRITHIV','A01','4699271928',2,10,'AA22','4879456790');
insert into CUSTOMER values('2345','GEETHA','A03','4699271929',3,15,'AA33','4879456791');
insert into CUSTOMER values('4567','JEYANTH','A04','4699271930',4,20,'AA44','4879456792');
insert into CUSTOMER values('6789','MUKUL','A05','4699271931',5,25,'AA55','4879456793');
insert into CUSTOMER values('1122','KAMESHWARI','A06','4699271932',1,5,'AA66','4879456794');
select * from customer;



CREATE TABLE POTATO_STOCK(
    Product_ID varchar(255) NOT NULL comment 'pk',
    Product_name VARCHAR(255) comment 'Potato name',
    Unit_quantity int comment 'quantity',
    Unit_price int comment 'price',
    Quantity_present int comment 'Quantity',
    Received_Date date comment 'Date',
    Purpose varchar(255) comment 'Purpose'
);

ALTER table potato_stock
ADD constraint PK_Product_ID Primary key(Product_ID);

insert into potato_stock values ('1111','SWEET',100,25,900,'2021-01-01','CHIPS');
insert into potato_stock values('2222','KING EDWARD',100,40,1200,'2021-01-02','RETAIL');
insert into potato_stock values('3333','KERRS PINK POTATO',100,60,2500,'2021-01-03','CHIPS');
insert into potato_stock values('4444','YUKON',100,50,400,'2021-01-04','CHIPS');
insert into potato_stock values('5555','BINTJE',100,70,3000,'2021-01-05','RETAIL');
SELECT * FROM potato_stock;

CREATE TABLE CUSTOMER_DISPATCH_REGISTER(
	Order_ID INT not null COMMENT 'PK',
    Customer_ID VARCHAR(255) COMMENT 'FK',
    Date_sent DATE COMMENT 'date sent',
    Date_Received DATE COMMENT 'DATE RECEIVED',
    Product_ID varchar(255) COMMENT 'Potato ID',
    Product_name VARCHAR(255) COMMENT 'Product name',    
    Quantity INT COMMENT 'Quantity',
    Price INT COMMENT 'Price'
);
alter table CUSTOMER_DISPATCH_REGISTER
ADD constraint PK_Order_ID PRIMARY KEY(Order_ID);

alter table CUSTOMER_DISPATCH_REGISTER
ADD constraint FK_Customer_ID FOREIGN KEY(Customer_ID)
REFERENCES customer(customer_ID) ;

alter table CUSTOMER_DISPATCH_REGISTER
ADD constraint FK_Product_ID FOREIGN KEY(Product_ID)
References potato_stock(product_ID);

insert into customer_dispatch_register values(10000000,'1234','2021-05-20','2021-05-21','1111','SWEET',40,25);
insert into customer_dispatch_register values(10000001,'3456','2021-05-25','2021-05-26','2222','KING EDWARD',35,40);
insert into customer_dispatch_register values(10000002,'2345','2021-05-30','2021-05-31','4444','YUKON',50,50);
insert into customer_dispatch_register values(10000003,'4567','2021-06-04','2021-06-05','1111','SWEET',90,25);
insert into customer_dispatch_register values(10000004,'6789','2021-06-09','2021-06-10','5555','BINTJE',55,70);
select * from customer_dispatch_register;

#INNER JOIN
select a.*,b.Zipcode
from customer a
INNER join customers_address b on a.customer_address_id=b.customer_address_id;

#LEFT OUTER JOIN
SELECT b.date_received as 'Customer_received_date',b.customer_ID,a.*
from customer_dispatch_Register b
left outer join potato_stock a on a.product_ID=b.product_ID
where a.product_ID='1111';

#RIGHT OUTER JOIN
SELECT a.product_name,b.*
from customer_dispatch_register a
right outer join customer b on a.customer_id=b.customer_ID;

#UNION
select a.* from customer_dispatch_register a where a.product_id='1111'
union
select b.* from customer_dispatch_register b where b.product_id='2222';

#EXCEPT(NOT WORKING IN MYSQL) SO USED THE ALTERNATIVE 'NOT IN' WHICH GIVES THE SAME OUTPUT
SELECT a.product_id,a.product_name
from potato_stock a where a.product_id not in(select a.product_id from potato_stock a where a.product_id='1111');