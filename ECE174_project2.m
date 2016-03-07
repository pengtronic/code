close all;
clear all;

b = 2.354788068e-3; %clock bias

s = [1.000000000 0.000000000 0.000000000]'; %receiver location

s_l=[3.585200000 2.070000000 0.000000000;
    2.927400000 2.927400000 0.000000000;
    2.661200000 0.000000000 3.171200000;
    1.415900000 0.000000000 3.890400000]'; %satellite positions
x_true = [s;b];

% standard deviation of the noise
sigma = 0.004;

% step size
alpha_k = 0.2;

for m = 256
    
    % simulate the pseudorange
    for i = 1:4
        for j = 1:m
            n1(j,1) = sigma*randn;
        end
        n = mean(n1);
        
        y(i,1) = sqrt((s - s_l(:,i))'*(s - s_l(:,i)))+b+n;
        
    end
    
    Sk = [0.93310 0.25000 0.258819]'; %initial guess of position
    b_hat = 0;  %initial guess of clock bias
    
    
    % implementation of gradient descent algorithm
     for k = 1:100
        for i=1:4
            rl = sqrt((Sk - s_l(:,i))'*(Sk - s_l(:,i)));
            Rs(i,:) = (Sk-s_l(:,i))'/rl;
        end
        
        for i=1:4
            for j=1:3
                r2(i,j) = Rs(i,j);
            end
        end
        
        for i=1:4
            r2(i,4) = 1;
        end
        
        H_i = inv(r2);
        
        x_k = [Sk;b_hat];
        
        for i=1:4
            rl = sqrt((Sk - s_l(:,i))'*(Sk - s_l(:,i)));
            Y(i,1) = y(i,1) - rl - b_hat;
        end
        
%         x_k_1 = x_k + alpha_k*r2'*Y; %Gradient Descent Method
        x_k_1 = x_k + alpha_k*H_i*Y; %Gauss' Method
        
        % error of the loss function
        l_k(1,k) = 0.5*Y'*Y;
        
        Sk=x_k_1(1:3,1);
        b_hat = x_k_1(4,1);
        
        % receiver position estimation error
        distance_error(1,k) = sqrt((Sk - s)'*(Sk - s))*6371;
        
        % receiver clock bias error
        clock_error(1,k) = abs(b_hat - b)*6371;
        
     end
    x_difference = abs((x_true-x_k_1)*6371); 
    
    k = 1:100;
    
    % plots for loss function, distance error, and clock bias error
    if m == 1
        subplot(3,1,1);
        plot(k,l_k,'r');
        title('loss function error');
        xlabel('number of iteration');
        ylabel('error(in meters)');
        hold on
        
        subplot(3,1,2);
        plot(k,distance_error,'r');
        title('distance error(Sk - s)');
        xlabel('number of iteration');
        ylabel('distance(in meters)');
        hold on
        
        subplot(3,1,3);
        plot(k,clock_error,'r');
        title('clock error');
        xlabel('number of iteration');
        ylabel('clock bias (in meters)');
        hold on
        
        %predicted (from the linearized dynamics) error standard deviations
        Sigma = (sigma^2/m)*eye(4);
        error1 = sqrt(inv(r2'*inv(Sigma)*r2))*6371;
        
    end
    
    if m == 4
        subplot(3,1,1);
        plot(k,l_k,'b');
        title('loss function error');
        xlabel('number of iteration');
        ylabel('error(in meters)');
        hold on
        
        subplot(3,1,2);
        plot(k,distance_error,'b');
        title('distance error(Sk - s)');
        xlabel('number of iteration');
        ylabel('distance(in meters)');
        hold on
        
        subplot(3,1,3);
        plot(k,clock_error,'b');
        title('clock error');
        xlabel('number of iteration');
        ylabel('clock bias (in meters)');
        hold on
        
        Sigma = (sigma^2/m)*eye(4);
        error2 = sqrt(inv(r2'*inv(Sigma)*r2))*6371;
    end
    
    if m == 16
        subplot(3,1,1);
        plot(k,l_k,'m');
        title('loss function error');
        xlabel('number of iteration');
        ylabel('error(in meters)');
        hold on
        
        subplot(3,1,2);
        plot(k,distance_error,'m');
        title('distance error(Sk - s)');
        xlabel('number of iteration');
        ylabel('distance(in meters)');
        hold on
        
        subplot(3,1,3);
        plot(k,clock_error,'m');
        title('clock error');
        xlabel('number of iteration');
        ylabel('clock bias (in meters)');
        hold on
        
        Sigma = (sigma^2/m)*eye(4);
        error3 = sqrt(inv(r2'*inv(Sigma)*r2))*6371;
    end
    
    if m == 256
        subplot(3,1,1);
        plot(k,l_k,'k');
        title('loss function error');
        xlabel('number of iteration');
        ylabel('error(in meters)');
        
        
        subplot(3,1,2);
        plot(k,distance_error,'k');
        title('distance error(Sk - s)');
        xlabel('number of iteration');
        ylabel('distance(in meters)');
        
        
        subplot(3,1,3);
        plot(k,clock_error,'k');
        title('clock error');
        xlabel('number of iteration');
        ylabel('clock bias (in meters)');
        
        Sigma = (sigma^2/m)*eye(4);
        error4 = sqrt(inv(r2'*inv(Sigma)*r2))*6371;
    end
end