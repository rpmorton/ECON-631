function [log_like] = llprobitsys(theta,y,x1,x2,z);
    %debug 
    
    %{
    theta = thetanullhat;
    y = work;
    x1 = age;
    x2 = educ;
    z = parenteduc;
    %}
    
    % Probability
    prob_y_1 = zeros(rows(y),1);
    mu = zeros(rows(y),1); 
    prob_x_2 = zeros(rows(y),1);

    for i = 1: rows(y) ;
        
    mu(i) =  (theta(1,7)/theta(1,8)) ...
        * (x2(i) - (theta(1,4) + theta(1,5) .* x1(i) + theta(1,6) .* z(i) ) );
    var(i) = 1 -  (theta(1,7)^2/theta(1,8) );
    
    prob_y_1(i) = 1 - normcdf(-theta(1,1) - theta(1,2) .* x1(i) - theta(1,3) .* x2(i) , ...
        mu(i), var(i) );
    
        if  prob_y_1(i) > .9999999
            prob_y_1(i) = .99999;
        end;
        if  prob_y_1(i)  < ( 1 - .9999999)
            prob_y_1(i) = .00001;
        end;
        
        prob_x_2(i) =  normpdf( mu(i) *  (theta(1,8)/theta(1,7)), 0, theta(1,8));
         if  prob_x_2(i)  < ( 1 - .9999999)
            prob_x_2(i) = .00001;
        end;
    end;
        
    % Log likelihood
    ln_like_vec = y .* log(prob_y_1) + (1 - y) .* log(1 - prob_y_1) + log(prob_x_2);
    log_like = -sum(ln_like_vec);
end