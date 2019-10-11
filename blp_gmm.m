function [gmm_obj] = blp_gmm(sigma,initial,shares,sims,x,price,instruments,tol,prod_ids);
 
    sigma = [.4 .5 .6];
    tol = 10 ^ -14;
    shares = market_share;
    sims = norm_rnd;
    x = horzcat(sugar,mushy);
    price = price;
    initial = mean_utility_by_prod;
    prod = product_id;
    
    %%
    %Berry Inverstion:
    delta_curr = initial;
    distance = 1;
    
    unique_prod_ids = unique(prod);
    pre_unique_prod_ids_row = 1:1:rows(unique_prod_ids);
    unique_prod_ids_row = horzcat(unique_prod_ids,pre_unique_prod_ids_row');
    
    %%CREATE LIST OF PROD ID BY ROW: SO FOR EACH PROD ID SAYS WHAT ROW
    %%SHOULD BE
    prod_lookup = horzcat(prod,zeros(rows(prod),1));
    
    for i = 1: rows(prod_lookup);
        prod_to_check = prod_lookup(i,1);
        same_prod = repmat(prod_to_check,rows(unique_prod_ids_row),1) == unique_prod_ids_row(:,1);
        lookup_num = max(same_prod .* unique_prod_ids_row(:,2));
        prod_lookup(i,2) = lookup_num;
    end;


   while distance > tol;
       
     delta_curr_expand = delta_curr(prod_lookup(:,2),:);
     for_random = horzcat(sugar,mushy,ones(rows(sugar),1));
     simul_random = for_random * (sigma' .* sims');
     share_num = exp(delta_curr_expand .* ones() +  simul_random);
     
        
    
    distance = sum(abs(delta_curr-delta_next));
    delta_curr = delta_next;
   end;
   
    gmm_obj = XX;
end