//vielle requette pour trouver un peu tout
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
, ps_customer.societe,  ps_order_invoice.number , ps_product_attribute.reference ,
 ps_cart_product.quantity , ps_product.price ,(ps_cart_product.quantity * ps_product.price ) Prix_Total_HT ,
 ( ps_order_detail.unit_price_tax_incl - ps_order_detail.unit_price_tax_excl ) TVA_Unitaire ,
 (( ps_order_detail.unit_price_tax_incl - ps_order_detail.unit_price_tax_excl ) * ps_cart_product.quantity ) TVA_Total ,
ps_order_invoice.total_shipping_tax_excl Frais_de_port , ps_order_invoice.total_shipping_tax_incl Frais_de_port_TTC ,
( (ps_cart_product.quantity * ps_product.price) + (( ps_order_detail.unit_price_tax_incl - ps_order_detail.unit_price_tax_excl )* ps_cart_product.quantity) + ps_order_invoice.total_shipping_tax_incl ) Prix_TTC ,
ps_order_invoice.total_paid_tax_excl Prix_Commande_complete_HT, ps_order_invoice.total_paid_tax_incl Prix_Commande_complete_TTC
from ps_orders inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join  ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_order_invoice on ps_orders.id_order=ps_order_invoice.id_order
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

INSERT into ps_MaTable(id_product) SELECT id_product FROM ps_product;

//requette pas optimisé alors que ça devrais :(
select ps2_orders.id_order , ps2_cart.id_cart , ps2_cart.id_customer , ps2_customer.firstname ,
 ps2_customer.lastname, ps2_customer.societe, ps2_product_attribute.reference ,
 ps2_cart_product.quantity , ps2_product.price ,(ps2_cart_product.quantity * ps2_product.price ) , ps2_order_invoice.number
from ps_orders ps2_orders inner join (select ps_cart.id_cart , ps_cart.id_customer from ps_cart  ) ps2_cart on ps2_orders.id_cart=ps2_cart.id_cart
inner join ( select ps_cart_product.id_cart , ps_cart_product.id_product , ps_cart_product.quantity , ps_cart_product.id_product_attribute from ps_cart_product  ) ps2_cart_product on ps2_orders.id_cart=ps2_cart_product.id_cart
inner join ( select ps_product_attribute.id_product_attribute, ps_product_attribute.reference from ps_product_attribute  ) ps2_product_attribute on ps2_cart_product.id_product_attribute=ps2_product_attribute.id_product_attribute
inner join ( select ps_product.id_product , ps_product.price from ps_product  ) ps2_product on ps2_product.id_product=ps2_cart_product.id_product
inner join ( select ps_order_invoice.id_order , ps_order_invoice.number from ps_order_invoice  ) ps2_order_invoice on ps2_orders.id_order=ps2_order_invoice.id_order
inner join ( select ps_customer.id_customer , ps_customer.firstname , ps_customer.lastname , ps_customer.societe from ps_customer  ) ps2_customer on ps2_orders.id_customer=ps2_customer.id_customer ;

INSERT into ps_MaTable(id_product , id_accountant) SELECT ps_product.id_product, tabledeux.id_accountant FROM ps_product join tabledeux;

//insertion prix HT
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,number,reference,price,PrixHT)
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
 ps_customer.societe,  'FAB'+'0'*(6-Length(ps_order_invoice.number))+ ps_order_invoice.number , ps_product_attribute.reference ,
 ps_order_detail.product_price ,(ps_cart_product.quantity * ps_order_detail.product_price ) * (1-ps_order_detail.reduction_percent/100)
from ps_orders inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join  ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_order_invoice on ps_orders.id_order=ps_order_invoice.id_order
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//insertion tva
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,number,code_comptable,price,PrixHT)
select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
 ps_customer.societe,  ps_order_invoice.number , 44572 ,
  (ps_order_invoice.total_products_wt - ps_order_invoice.total_products) ,
  (ps_order_invoice.total_products_wt - ps_order_invoice.total_products)
from ps_orders inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join  ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_order_invoice on ps_orders.id_order=ps_order_invoice.id_order
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//insertion des frais de transport
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,number,code_comptable,price,PrixHT)
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
 ps_customer.societe,  Frais_de_port.number , 708500 ,
  Frais_de_port.total_shipping_tax_excl , Frais_de_port.total_shipping_tax_excl
from (select * from ps_order_invoice where ps_order_invoice.total_shipping_tax_excl>0) Frais_de_port
inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//insertion TVA des frais de transport
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,number,code_comptable,price,PrixHT)
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
  ps_customer.societe,  Frais_de_port.number , 708500 ,
  Frais_de_port.total_shipping_tax_incl - Frais_de_port.total_shipping_tax_excl ,
  Frais_de_port.total_shipping_tax_incl - Frais_de_port.total_shipping_tax_excl
from (select * from ps_order_invoice where ps_order_invoice.total_shipping_tax_incl - ps_order_invoice.total_shipping_tax_excl>0) Frais_de_port
inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//insertion toute la TVA
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,number,code_comptable,price,PrixHT)
select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
  ps_customer.societe, Frais_de_port.number , 445712 ,
  Frais_de_port.total_paid_tax_incl - Frais_de_port.total_paid_tax_excl ,
  Frais_de_port.total_paid_tax_incl - Frais_de_port.total_paid_tax_excl
from  ps_order_invoice Frais_de_port
inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

'FAB'+'0'*(6-Length(champs))+champs

///////////////////////////////////////////////////////////////
//Prix HT
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,reference,Total,Moyen_Paiement)
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
 ps_customer.societe, Frais_de_port.date_add,  Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , ps_product_attribute.reference ,
 ROUND((ps_cart_product.quantity * ps_order_detail.product_price ) * (1-ps_order_detail.reduction_percent/100)-0.005,2),ps_orders.payment
 from (select distinct * from ps_order_invoice
   WHERE (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1 and Year(date_add)=Year(CURRENT_DATE))
    or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
 join ps_orders on ps_orders.id_order=Frais_de_port.id_order
 inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
 inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
 inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
 inner join ps_product on ps_product.id_product=ps_cart_product.id_product
 inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
 inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//Frais de port
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,Total,Moyen_Paiement)
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
 ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 708500 ,
 Frais_de_port.total_shipping_tax_excl, ps_orders.payment
from (select * from ps_order_invoice where ps_order_invoice.total_shipping_tax_excl>0
  and (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1 and Year(date_add)=Year(CURRENT_DATE))
  or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//TVA
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,Total,Moyen_Paiement)
select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
  ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 445712 ,
  Frais_de_port.total_paid_tax_incl - Frais_de_port.total_paid_tax_excl , ps_orders.payment
  from (select * from ps_order_invoice WHERE (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1
    and Year(date_add)=Year(CURRENT_DATE))
    or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
  inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
  inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
  inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
  inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
  inner join ps_product on ps_product.id_product=ps_cart_product.id_product
  inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
  inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//Total_TTC
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,Total,Moyen_Paiement)
select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
  ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 499999 ,
  Frais_de_port.total_paid_tax_incl , ps_orders.payment
  from (select * from ps_order_invoice WHERE (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1
    and Year(date_add)=Year(CURRENT_DATE))
    or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
  inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
  inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
  inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
  inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
  inner join ps_product on ps_product.id_product=ps_cart_product.id_product
  inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
  inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

  //remise
  Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,Total,Moyen_Paiement)
  select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
    ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 709600 ,
    Frais_de_port.total_discount_tax_excl , ps_orders.payment
    from (select * from ps_order_invoice WHERE total_discount_tax_excl>0 and (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1
      and Year(date_add)=Year(CURRENT_DATE))
      or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
    inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
    inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
    inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
    inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
    inner join ps_product on ps_product.id_product=ps_cart_product.id_product
    inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
    inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

    //avoir
    Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,total,moyen_paiement)
    select ORDERS.id_order , ps_cart.id_cart , ps_cart.id_customer ,
      ps_customer.societe, ps_order_payment.date_add, ps_order_payment.transaction_id ,
        101010 , ps_order_payment.amount
      , ORDERS.payment
    from (select * from ps_orders where total_paid_real > 0 and total_paid_tax_incl > total_paid_real) ORDERS
    inner join ps_order_payment on ORDERS.reference=ps_order_payment.order_reference
    and (MONTH(CURRENT_DATE)>1 and MONTH(ps_order_payment.date_add) = MONTH(CURRENT_DATE)-1
      and Year(ps_order_payment.date_add)=Year(CURRENT_DATE))
      or (MONTH(CURRENT_DATE)=1 and MONTH(ps_order_payment.date_add)=12 and Year(ps_order_payment.date_add)=Year(CURRENT_DATE)-1)
    inner join ps_cart on ORDERS.id_cart=ps_cart.id_cart
    inner join ps_customer on ORDERS.id_customer=ps_customer.id_customer;

///////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////

CREATE TABLE `copieBD`.`ps_bilan_comptable` ( `id_order` INT(10) NOT NULL , `id_cart` INT(10) NOT NULL ,
`id_customer` INT(10) NOT NULL , `societe` TEXT NOT NULL , `date` DATE NOT NULL , `number` CHAR(10) NOT NULL ,
 `reference` INT(10) NOT NULL , `code_comptable` INT(10) NOT NULL , `total` FLOAT(10) NOT NULL ,
  `moyen_paiement` CHAR(20) NOT NULL ) ENGINE = InnoDB;

//Prix HT
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,reference,total,moyen_paiement)
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
 ps_customer.societe, Frais_de_port.date_add,  Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , ps_product_attribute.reference ,
 ps_order_detail.total_price_tax_excl ,ps_orders.payment
 from (select distinct * from ps_order_invoice
   WHERE (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1 and Year(date_add)=Year(CURRENT_DATE))
    or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
 join ps_orders on ps_orders.id_order=Frais_de_port.id_order
 inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
 inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
 inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
 inner join ps_product on ps_product.id_product=ps_cart_product.id_product
 inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
 inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//Frais de port
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,total,moyen_paiement)
select ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
 ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 708500 ,
 Frais_de_port.total_shipping_tax_excl, ps_orders.payment
from (select * from ps_order_invoice where ps_order_invoice.total_shipping_tax_excl>0
  and (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1 and Year(date_add)=Year(CURRENT_DATE))
  or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
inner join ps_product on ps_product.id_product=ps_cart_product.id_product
inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//TVA
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,total,moyen_paiement)
select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
  ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 445712 ,
  Frais_de_port.total_paid_tax_incl - Frais_de_port.total_paid_tax_excl , ps_orders.payment
  from (select * from ps_order_invoice WHERE (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1
    and Year(date_add)=Year(CURRENT_DATE))
    or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
  inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
  inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
  inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
  inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
  inner join ps_product on ps_product.id_product=ps_cart_product.id_product
  inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
  inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

//Total_TTC
Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,total,moyen_paiement)
select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
  ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 499999 ,
  Frais_de_port.total_paid_tax_incl , ps_orders.payment
  from (select * from ps_order_invoice WHERE (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1
    and Year(date_add)=Year(CURRENT_DATE))
    or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
  inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
  inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
  inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
  inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
  inner join ps_product on ps_product.id_product=ps_cart_product.id_product
  inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
  inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

  //remise
  Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,total,moyen_paiement)
  select distinct ps_orders.id_order , ps_cart.id_cart , ps_cart.id_customer ,
    ps_customer.societe, Frais_de_port.date_add, Concat('FAB',Repeat('0',(6-Length(Frais_de_port.number))),Convert(Frais_de_port.number, CHAR)) , 709600 ,
    Frais_de_port.total_discount_tax_excl , ps_orders.payment
    from (select * from ps_order_invoice WHERE total_discount_tax_excl>0 and
       (MONTH(CURRENT_DATE)>1 and MONTH(date_add) = MONTH(CURRENT_DATE)-1 and Year(date_add)=Year(CURRENT_DATE))
      or (MONTH(CURRENT_DATE)=1 and MONTH(date_add)=12 and Year(date_add)=Year(CURRENT_DATE)-1)) Frais_de_port
    inner join ps_orders on ps_orders.id_order=Frais_de_port.id_order
    inner join ps_cart on ps_orders.id_cart=ps_cart.id_cart
    inner join ps_cart_product on ps_orders.id_cart=ps_cart_product.id_cart
    inner join ps_product_attribute on ps_cart_product.id_product_attribute=ps_product_attribute.id_product_attribute
    inner join ps_product on ps_product.id_product=ps_cart_product.id_product
    inner join ps_customer on ps_orders.id_customer=ps_customer.id_customer
    inner join ps_order_detail on ps_order_detail.id_order=ps_orders.id_order and ps_order_detail.product_id=ps_cart_product.id_product;

    //avoir TTC
    Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,total,moyen_paiement)
    select ORDERS.id_order , ps_cart.id_cart , ps_cart.id_customer ,
      ps_customer.societe, ps_order_payment.date_add, ps_order_payment.transaction_id ,
        101010 , ps_order_payment.amount
      , ORDERS.payment
    from (select * from ps_orders where total_paid_real > 0 and total_paid_tax_incl > total_paid_real
      and (MONTH(CURRENT_DATE)>1 and MONTH(ps_orders.date_add) <= MONTH(CURRENT_DATE)-1
      and Year(ps_orders.date_add)=Year(CURRENT_DATE))
      or (MONTH(CURRENT_DATE)=1 and MONTH(ps_orders.date_add)<=12 and Year(ps_orders.date_add)=Year(CURRENT_DATE)-1)) ORDERS
    join ps_order_payment on ORDERS.reference=ps_order_payment.order_reference
    and (MONTH(CURRENT_DATE)>1 and MONTH(ps_order_payment.date_add) = MONTH(CURRENT_DATE)-1
      and Year(ps_order_payment.date_add)=Year(CURRENT_DATE))
      or (MONTH(CURRENT_DATE)=1 and MONTH(ps_order_payment.date_add)=12 and Year(ps_order_payment.date_add)=Year(CURRENT_DATE)-1)
    inner join ps_cart on ORDERS.id_cart=ps_cart.id_cart
    inner join ps_customer on ORDERS.id_customer=ps_customer.id_customer;

    //TVA - Avoir TVA
    Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number,code_comptable,total,moyen_paiement)
    select ORDERS.id_order , ps_cart.id_cart , ps_cart.id_customer ,
      ps_customer.societe, ps_order_payment.date_add, ps_order_payment.transaction_id ,
        445712 , (ps_order_invoice.total_paid_tax_incl - ps_order_invoice.total_paid_tax_excl) - (ps_order_slip_detail.amount_tax_incl - ps_order_slip_detail.amount_tax_excl)
      , ORDERS.payment
      from (select * from ps_orders where total_paid_real > 0 and total_paid_tax_incl > total_paid_real
        and (MONTH(CURRENT_DATE)>1 and MONTH(ps_orders.date_add) <= MONTH(CURRENT_DATE)-1
        and Year(ps_orders.date_add)=Year(CURRENT_DATE))
        or (MONTH(CURRENT_DATE)=1 and MONTH(ps_orders.date_add)<=12 and Year(ps_orders.date_add)=Year(CURRENT_DATE)-1)) ORDERS
      join ps_order_payment on ORDERS.reference=ps_order_payment.order_reference
      and (MONTH(CURRENT_DATE)>1 and MONTH(ps_order_payment.date_add) = MONTH(CURRENT_DATE)-1
        and Year(ps_order_payment.date_add)=Year(CURRENT_DATE))
        or (MONTH(CURRENT_DATE)=1 and MONTH(ps_order_payment.date_add)=12 and Year(ps_order_payment.date_add)=Year(CURRENT_DATE)-1)
      inner join ps_cart on ORDERS.id_cart=ps_cart.id_cart
      inner join ps_customer on ORDERS.id_customer=ps_customer.id_customer
      inner join ps_order_invoice on ORDERS.id_order=ps_order_invoice.id_order
      inner join ps_order_slip on ORDERS.id_order=ps_order_slip.id_order
      inner join ps_order_slip_detail on ps_order_slip.id_order_slip=ps_order_slip_detail.id_order_slip;

    //TTC - Avoir TTC
    Insert into ps_bilan_comptable(id_order,id_cart,id_customer,societe,date,number, code_comptable ,total,moyen_paiement)
    select ORDERS.id_order , ps_cart.id_cart , ps_cart.id_customer ,
      ps_customer.societe, ps_order_payment.date_add, ps_order_payment.transaction_id ,
        499999 , ORDERS.total_paid_tax_incl - ps_order_slip_detail.amount_tax_incl
      , ORDERS.payment
    from (select * from ps_orders where total_paid_real > 0 and total_paid_tax_incl > total_paid_real
      and (MONTH(CURRENT_DATE)>1 and MONTH(ps_orders.date_add) <= MONTH(CURRENT_DATE)-1
      and Year(ps_orders.date_add)=Year(CURRENT_DATE))
      or (MONTH(CURRENT_DATE)=1 and MONTH(ps_orders.date_add)<=12 and Year(ps_orders.date_add)=Year(CURRENT_DATE)-1)) ORDERS
    join ps_order_payment on ORDERS.reference=ps_order_payment.order_reference
    and (MONTH(CURRENT_DATE)>1 and MONTH(ps_order_payment.date_add) = MONTH(CURRENT_DATE)-1
      and Year(ps_order_payment.date_add)=Year(CURRENT_DATE))
      or (MONTH(CURRENT_DATE)=1 and MONTH(ps_order_payment.date_add)=12 and Year(ps_order_payment.date_add)=Year(CURRENT_DATE)-1)
    inner join ps_cart on ORDERS.id_cart=ps_cart.id_cart
    inner join ps_customer on ORDERS.id_customer=ps_customer.id_customer
    inner join ps_order_slip on ORDERS.id_order=ps_order_slip.id_order
    inner join ps_order_slip_detail on ps_order_slip.id_order_slip=ps_order_slip_detail.id_order_slip
    inner join ps_order_detail on ORDERS.id_order=ps_order_detail.id_order;
