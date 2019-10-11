%%
%Created by RM on 2019.10.03 for  ECON 631 PS 1


%%%%%%%%%%%%%%%%%%%%%%%%
%   Import Data
%%%%%%%%%%%%%%%%%%%%%%%%

data = readtable('/Users/russellmorton/Desktop/Coursework/Fall 2019/ECON 631/Problem Sets/cereal_data.xlsx');
product_id = table2array(data(:,1));
firm_id = table2array(data(:,2));
city = table2array(data(:,3));
year = table2array(data(:,4));
quarter = table2array(data(:,5));
market_share = table2array(data(:,6));
price = table2array(data(:,7));
sugar =  table2array(data(:,8));
mushy =  table2array(data(:,9));

%%
%%%%%%%%%%%%%%%%%%%%%%%%
%  Simulation Draws
%%%%%%%%%%%%%%%%%%%%%%%%

norm_rnd = normrnd(0,1,[5000,3]);


%%
%%%%%%%%%%%%%%%%%%%%%%%%
%  Berry Inversion
%%%%%%%%%%%%%%%%%%%%%%%%

subs = findgroups(city,year,quarter);

sum_market_share = accumarray(subs,market_share);
subs_sum_market_share = horzcat(sum_market_share,unique(subs));
expand_sum_market_share = subs_sum_market_share(subs(:,1));

BLP_lhs = log(market_share) - log(1 - expand_sum_market_share);

BLP_rhs = horzcat(price,sugar,mushy,ones(rows(price),1));

%First guess: logit mean utility

beta_ols = inv(BLP_rhs' * BLP_rhs) * (BLP_rhs' * BLP_lhs);
utility_hat = BLP_rhs * beta_ols;
mean_utility_all_prod = accumarray(product_id,utility_hat,[],@mean);
unique_prod_ids = unique(product_id);
mean_utility_by_prod = mean_utility_all_prod(unique_prod_ids,:);

tol = 10 ^ -14;







