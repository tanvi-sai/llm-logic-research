% Business Operations Knowledge Base
% Facts: Customer Behavior, Products, and Business Rules

% Customer purchase history
purchased(alice, laptop).
purchased(alice, mouse).
purchased(alice, warranty_plan).
purchased(bob, smartphone).
purchased(bob, phone_case).
purchased(carol, tablet).
purchased(carol, stylus).
purchased(carol, cloud_storage).
purchased(david, laptop).
purchased(david, external_monitor).
purchased(emily, smartwatch).
purchased(frank, wireless_earbuds).
purchased(frank, charging_dock).

% Customer loyalty status
loyalty_member(alice, gold).
loyalty_member(bob, silver).
loyalty_member(carol, gold).
loyalty_member(david, bronze).
loyalty_member(emily, silver).
loyalty_member(frank, bronze).

% Product categories
category(laptop, electronics).
category(smartphone, electronics).
category(tablet, electronics).
category(smartwatch, electronics).
category(wireless_earbuds, electronics).
category(mouse, accessories).
category(phone_case, accessories).
category(stylus, accessories).
category(charging_dock, accessories).
category(external_monitor, accessories).
category(warranty_plan, services).
category(cloud_storage, services).

% Product prices (in dollars)
price(laptop, 1200).
price(smartphone, 800).
price(tablet, 600).
price(smartwatch, 400).
price(wireless_earbuds, 150).
price(mouse, 30).
price(phone_case, 25).
price(stylus, 80).
price(charging_dock, 45).
price(external_monitor, 300).
price(warranty_plan, 200).
price(cloud_storage, 120).

% Product compatibility (complementary products)
compatible(laptop, mouse).
compatible(laptop, external_monitor).
compatible(laptop, warranty_plan).
compatible(smartphone, phone_case).
compatible(smartphone, wireless_earbuds).
compatible(tablet, stylus).
compatible(tablet, cloud_storage).
compatible(smartwatch, charging_dock).
compatible(wireless_earbuds, charging_dock).

% Customer budget tiers
budget_tier(alice, premium).
budget_tier(bob, mid_range).
budget_tier(carol, premium).
budget_tier(david, mid_range).
budget_tier(emily, budget).
budget_tier(frank, budget).

% Purchase timestamps (month)
purchased_month(alice, laptop, january).
purchased_month(alice, mouse, january).
purchased_month(alice, warranty_plan, february).
purchased_month(bob, smartphone, february).
purchased_month(bob, phone_case, february).
purchased_month(carol, tablet, march).
purchased_month(carol, stylus, march).
purchased_month(carol, cloud_storage, april).
purchased_month(david, laptop, april).
purchased_month(david, external_monitor, may).
purchased_month(emily, smartwatch, may).
purchased_month(frank, wireless_earbuds, june).
purchased_month(frank, charging_dock, june).

% Product stock status
in_stock(laptop).
in_stock(smartphone).
in_stock(tablet).
in_stock(mouse).
in_stock(phone_case).
in_stock(stylus).
in_stock(charging_dock).
out_of_stock(smartwatch).
out_of_stock(wireless_earbuds).
out_of_stock(external_monitor).
out_of_stock(warranty_plan).
out_of_stock(cloud_storage).

% ===== RULES =====

% High-value customer: gold loyalty member
high_value_customer(Customer) :-
    loyalty_member(Customer, gold).

% Customer bought from category
bought_category(Customer, Category) :-
    purchased(Customer, Product),
    category(Product, Category).

% Customer is eligible for discount (gold/silver members)
eligible_for_discount(Customer) :-
    loyalty_member(Customer, gold).
eligible_for_discount(Customer) :-
    loyalty_member(Customer, silver).

% Cross-sell opportunity: customer bought product but not its complement
cross_sell_opportunity(Customer, Product) :-
    purchased(Customer, MainProduct),
    compatible(MainProduct, Product),
    \+ purchased(Customer, Product).

% Upsell candidate: customer in premium/mid_range tier who hasn't bought high-value items
upsell_candidate(Customer, Product) :-
    budget_tier(Customer, premium),
    price(Product, Price),
    Price > 500,
    \+ purchased(Customer, Product).

upsell_candidate(Customer, Product) :-
    budget_tier(Customer, mid_range),
    price(Product, Price),
    Price > 300,
    Price =< 800,
    \+ purchased(Customer, Product).

% Product recommendation based on purchase history
recommended_product(Customer, Product) :-
    cross_sell_opportunity(Customer, Product),
    in_stock(Product).

% Customer spent over threshold (high spender)
high_spender(Customer) :-
    findall(Price, (purchased(Customer, Product), price(Product, Price)), Prices),
    sum_list(Prices, Total),
    Total > 1000.

% Customers are similar if they bought products from same category
similar_customers(Customer1, Customer2) :-
    bought_category(Customer1, Category),
    bought_category(Customer2, Category),
    Customer1 \= Customer2.

% Product bundle: two products that are compatible
product_bundle(Product1, Product2) :-
    compatible(Product1, Product2).

product_bundle(Product1, Product2) :-
    compatible(Product2, Product1).

% Repeat customer: purchased more than 2 items
repeat_customer(Customer) :-
    findall(Product, purchased(Customer, Product), Products),
    length(Products, Count),
    Count > 2.

% Customer bought in recent months (March onwards)
recent_buyer(Customer) :-
    purchased_month(Customer, _, Month),
    member(Month, [march, april, may, june]).

% Premium product: price over 500
premium_product(Product) :-
    price(Product, Price),
    Price > 500.

% Budget product: price under 100
budget_product(Product) :-
    price(Product, Price),
    Price < 100.

% Customer preference analysis: if bought mostly from one category
prefers_category(Customer, Category) :-
    findall(Cat, (purchased(Customer, P), category(P, Cat)), Categories),
    length(Categories, Total),
    Total > 1,
    findall(Cat, (purchased(Customer, P), category(P, Category)), MatchingCats),
    length(MatchingCats, Count),
    Count > Total / 2.

% Churn risk: bronze member who hasn't purchased recently
churn_risk(Customer) :-
    loyalty_member(Customer, bronze),
    \+ recent_buyer(Customer).

% VIP customer: gold member AND high spender
vip_customer(Customer) :-
    loyalty_member(Customer, gold),
    high_spender(Customer).

% Product out of stock but compatible with purchased item
restock_priority(Product) :-
    out_of_stock(Product),
    purchased(_, MainProduct),
    compatible(MainProduct, Product).

% Customer lifetime value tier
customer_value_tier(Customer, high) :-
    vip_customer(Customer).

customer_value_tier(Customer, medium) :-
    high_spender(Customer),
    \+ loyalty_member(Customer, gold).

customer_value_tier(Customer, low) :-
    \+ high_spender(Customer).

% Next best action: recommend product to customer
next_best_action(Customer, recommend(Product)) :-
    recommended_product(Customer, Product).

% Product affinity: customers who bought Product1 often buy Product2
product_affinity(Product1, Product2) :-
    compatible(Product1, Product2),
    purchased(Customer1, Product1),
    purchased(Customer1, Product2),
    purchased(Customer2, Product1),
    purchased(Customer2, Product2),
    Customer1 \= Customer2.

