function [gmm_obj] = blp_gmm(sigma,initial,shares,sims,x,price,instruments,tol);
 
    blp_counter = .5;
    blp_counter = blp_counter + .5


%%
%{
    sigma = [.4 .5];
    tol = 10 ^ -11;
    shares = market_share;
    sims = norm_rnd;
    x = horzcat(sugar,mushy);
    price = price;
    initial = mean_utility;
    instruments = instruments;
 %}   
    %%
    %Berry Inverstion:  
    sigma_exp = exp(sigma);
    
    delta_curr = initial;
    distance = 1;
    iter = 0;
    
    distance_tracker = ones(10000,1);

   while distance > tol;
       
     attributes = x;
     idiosyncratic_utility = attributes * (sigma_exp' .* sims');
     share_numerator_hat = exp(delta_curr .* ones(rows(delta_curr),columns(idiosyncratic_utility)) ...
         +  idiosyncratic_utility);
     share_hat = share_numerator_hat ./ (1 +  share_numerator_hat);
     mean_share_hat = mean(share_hat,2);
     delta_next = delta_curr + log(shares) - log(mean_share_hat);
     distance = sum(abs(delta_next - delta_curr));
      
     delta_curr = delta_next;
     iter = iter + 1;
     distance_tracker(iter) = distance;
   end;
   
   %%
   %IV Regression to back out the betas and price sensitivity
   first_stage_lhs = horzcat(instruments,ones(rows(instruments),1));
   beta_price_hat = inv(first_stage_lhs' * first_stage_lhs) * (first_stage_lhs' * price);
   price_hat = first_stage_lhs * beta_price_hat;
   
   BLP_LHS = horzcat(x,price_hat,ones(rows(x),1));
   beta_blp = inv(BLP_LHS' * BLP_LHS) * (BLP_LHS' * delta_curr);
   
   
   %%
   %compute obj fct val
   iv_resid = delta_curr - BLP_LHS * beta_blp;
   pre_gmm_resid = iv_resid' * instruments;
   gmm_resid = pre_gmm_resid * pre_gmm_resid';
   gmm_obj = gmm_resid;
   
   blp_counter = blp_counter + .5
   
end