//
//  Order.m
//  EWF
//
//  Created by Adrien Guffens on 7/3/13.
//  Copyright (c) 2013 Adrien Guffens. All rights reserved.
//

#import "Order.h"
#import "Address.h"
#import "Cart.h"
#import "Customer.h"
#import "OrderRow.h"
#import "OrderState.h"


@implementation Order

@dynamic carrier_tax_rate;
@dynamic conversion_rate;
@dynamic current_state;
@dynamic date_add;
@dynamic date_upd;
@dynamic delivery_date;
@dynamic delivery_number;
@dynamic gift;
@dynamic id_address_delivery;
@dynamic id_address_invoice;
@dynamic id_carrier;
@dynamic id_cart;
@dynamic id_currency;
@dynamic id_customer;
@dynamic id_lang;
@dynamic id_order;
@dynamic id_shop;
@dynamic id_shop_group;
@dynamic invoice_date;
@dynamic invoice_number;
@dynamic module;
@dynamic payment;
@dynamic reference;
@dynamic secure_key;
@dynamic total_discounts;
@dynamic total_discounts_tax_incl;
@dynamic total_paid;
@dynamic total_paid_real;
@dynamic total_paid_tax_excl;
@dynamic total_paid_tax_incl;
@dynamic total_products;
@dynamic total_products_wt;
@dynamic total_shipping;
@dynamic total_shipping_tax_excl;
@dynamic total_shipping_tax_incl;
@dynamic total_wrapping;
@dynamic total_wrapping_tax_excl;
@dynamic total_wrapping_tax_incl;
@dynamic valid;
@dynamic addressDelivery;
@dynamic addressInvoice;
@dynamic cart;
@dynamic orderRow;
@dynamic orderState;
@dynamic customer;

@end
