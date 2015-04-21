%%  MEROS E
%%  
%% To meros auto akolou9ei to Meros D ths ergasias, alla stoxeuei se
%% modelopoihsh me modelopoihsh me bash meigma apo Gaussians (GMM).
%%

clear; clc;
disp('MEROS E');
pause;
clc;

%% E.1
%% Epanalabete ta bhmata D.1-D.3
%%

disp('Meros E.1');
disp('------------');

P = [0.5, 0.5];
l = 2; M = 4; N = 1000; n = N/4;
randn('seed',0);

MU1 = [0,0]; MU2 = [2,2]; MU3 = [2,0]; MU4 = [4,2];
SIGMA = [0.6 0.4 ; 0.4 0.6];
r1 = mvnrnd(MU1,SIGMA,n);
r2 = mvnrnd(MU2,SIGMA,n);
r3 = mvnrnd(MU3,SIGMA,n);
r4 = mvnrnd(MU4,SIGMA,n);

disp('Figure1 shows the data for 4 classes');

figure(1);
plot(r1(:,1),r1(:,2),'g+');
hold on;
plot(r2(:,1),r2(:,2),'b+');
hold on;
plot(r3(:,1),r3(:,2),'m+');
hold on;
plot(r4(:,1),r4(:,2),'r+');
legend('class ù1','class ù2','class ù3','class ù4');

data1 = fusion(r1,r2);
data2 = fusion(r3,r4);

M = 2; n = N/2;

figure(2);
plot(data1(:,1),data1(:,2),'b+');
hold on;
plot(data2(:,1),data2(:,2),'r+');
legend('class ù1','class ù2');

disp('Figure2 shows the data for the fusioned classes');

disp('Press any key to continue');
pause;
clc;

%% E.2
%% 9ewrhste oti oi dyo klaseis modelopoioudai me ena meigma apo dyo 2-D
%% Gaussians h ka9e mia. Tre3te ton algori9mo Expectation-Maximazation gia
%% enan ari9mo epanalhpsewn, arxikopoiwdastis meses times me mia mikrh
%% diatara3h (perturbation) apo tis times tou bhmatos D.4 (Gaussian mixture
%% splitting).
%% 
%% E.3
%% Se ka9e epanalhpsh tou algori9mou ypologisate thn synolikh pi9anofaneia
%% twn dedomenwn, opws kai to sfalma ta3inomhshs tou prkyptoda bayesian 
%% ta3inomhth. Ti parathreite;
%%

disp('Meros E.2/E.3');
disp('------------');

J = 2;
m1 = [0.9751, 0.9860];
m2 = [2.9817, 0.9947];
S1 = [1.5573, 1.3473 ; 1.3473, 1.5469];
S2 = [1.6862, 1.4641 ; 1.4641, 1.6335];

% Expectation-Maximazation Algorithm
data = fusion(data1,data2);
maxIter = 100;

% initialazations

p = [0.6, 0.4];
mean1 = [0.8, 0.8];
mean2 = [2.0, 0.5];
cov1 = [1.5, 1.3 ; 1.3, 1.5];
cov2 = [1.6, 1.4 ; 1.4, 1.6];

prob = zeros(N,J);

probErr = zeros(maxIter,J);
meanErr = zeros(maxIter,J);
covErr = zeros(maxIter,J);
bayErr = zeros(maxIter,1);
iter = [1:maxIter];

disp(['Expectation-Maximazation algorithm for ',num2str(maxIter),' loops']);

for k=1:maxIter
     
% E-step
    for i=1:N
        denom = (p(1)*gaussianPdf(data(i,:),mean1,cov1) + p(2)*gaussianPdf(data(i,:),mean2,cov2));
        prob(i,1) = p(1)*gaussianPdf(data(i,:),mean1,cov1)/denom;
        prob(i,2) = p(2)*gaussianPdf(data(i,:),mean2,cov2)/denom;        
    end
% M-step

% class conditional probability
    p(1) = 0;
    p(2) = 0;
    for i=1:N
        for j=1:J
            p(j) = p(j) + prob(i,j);
        end
    end
    p(1) = p(1)/N;
    p(2) = p(2)/N;

% mean
    mean1 = [0 0];
    mean2 = [0 0];
    num = [0 0 ; 0 0]; den = [0 0];
    for i=1:N
        for j=1:J
            num(j,:) = num(j,:) + prob(i,j)*data(i,:);
            den(j) = den(j) + prob(i,j);
        end
    end
    mean1 = num(1,:)/den(1);
    mean2 = num(2,:)/den(2);

%covarience
    cov1 = zeros(M,l);
    cov2 = zeros(M,l);
    den = [0 0];
    for i=1:N
        cov1 = cov1 + prob(i,1)*(data(i,:)-mean1)' * (data(i,:)-mean1);
        cov2 = cov2 + prob(i,2)*(data(i,:)-mean2)' * (data(i,:)-mean2);
        den(1) = den(1) + prob(i,1);
        den(2) = den(2) + prob(i,2);
    end
    cov1 = cov1/den(1);
    cov2 = cov2/den(2);
    
% berore we start the next loop we calculate the errors
% of the probabilities, means and covarience matrices
    probErr(k,1) = norm(p(1)-P(1))/norm(P(1)); 
    probErr(k,2) = norm(p(2)-P(2))/norm(P(2)); 

    meanErr(k,1) = norm(m1-mean1)/norm(m1);
    meanErr(k,2) = norm(m2-mean2)/norm(m2);
        
    covErr(k,1) = norm(S1-cov1)/norm(S1);
    covErr(k,2) = norm(S2-cov2)/norm(S2); 
    
% we also need to calculate the number of errors the 
% bayesian classifier gives us
    % bayesian method for the data
    g1 = zeros(n,M);
    g2 = zeros(n,M);
    c = zeros(1,M);
    
    c(1) = -0.5*l*log(2*pi)-0.5*log(det(cov1));
    c(2) = -0.5*l*log(2*pi)-0.5*log(det(cov2));

    for i=1:n
      g1(i,1) = -0.5*((data1(i,:)-mean1)/cov1) *(data1(i,:)-mean1)' + log(p(1)) + c(1);
      g1(i,2) = -0.5*((data1(i,:)-mean2)/cov2) *(data1(i,:)-mean2)' + log(p(2)) + c(2);

      g2(i,1) = -0.5*((data2(i,:)-mean1)/cov1) *(data2(i,:)-mean1)' + log(p(1)) + c(1);
      g2(i,2) = -0.5*((data2(i,:)-mean2)/cov2) *(data2(i,:)-mean2)' + log(p(2)) + c(2);

    end

    errors = 0;

    for i=1:n
       if (find_max_pos(g1(i,:))~= 1)
           errors = errors + 1;
       end
       if (find_max_pos(g2(i,:))~= 2)
           errors = errors + 1;
       end
    end
    bayErr(k,1) = errors;
    
end

% plot the probability error-iteration diagramm for the two classes
figure(3);
subplot(2,1,1),plot(iter,probErr(:,1)');
title('Relative probability error for class ù1');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('error');

subplot(2,1,2),plot(iter,probErr(:,2)');
title('Relative probability error for class ù2');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('error');

% plot the mean error-iteration diagramm for the two classes
figure(4);
subplot(2,1,1),plot(iter,meanErr(:,1)');
title('Relative mean error for class ù1');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('error');

subplot(2,1,2),plot(iter,meanErr(:,2)');
title('Relative mean error for class ù2');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('error');

% plot the covarience error-iteration diagramm for the two classes
figure(5);
subplot(2,1,1),plot(iter,covErr(:,1)');
title('Relative covarience error for class ù1');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('error');

subplot(2,1,2),plot(iter,covErr(:,2)');
title('Relative covarience error for class ù2');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('error');

% plot the bayesian error-iteration diagramm for the two classes
figure(6);
plot(iter,bayErr);
title('Bayesian classifier errors');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('errors');

% display results on screen
disp('Probability, mean and covarience for class 1 : ');
disp('Probability : '); p(1)
disp('Mean : '); mean1
disp('Covarience : '); cov1

disp('Probability, mean and covarience for class 2 : ');
disp('Probability : '); p(2)
disp('Mean : '); mean2
disp('Covarience : '); cov2

disp('Press any key to continue');
pause;
clc;

%% E.4
%% Epanalabete ta bhmata E.2 kai E.3 arxikopoiwdas tis synolika 4
%% synistwses (dyo synistwses meigmatwn gia ka9e mia apo tis dyo klaseis)
%% me tis adistoixes meses times ths e3.(1) kai mhtrwo syndiasporas ths
%% e3.(3). Ti parathreite se sxesh me ta diagrammata tou bhmatos E.3;
%%

disp('Meros E.4');
disp('------------');

m1 = [0, 0]; m2 = [2, 2]; m3 = [2, 0]; m4 = [4, 2];
S = [0.6, 0.4 ; 0.4, 0.6]; P = [0.25, 0.25, 0.25, 0.25];

% Expectation-Maximazation Algorithm
data = fusion(data1,data2);
maxIter = 100;
J = 4;

% initialazations

p = [0.15, 0.3, 0.4, 0.15];
mean1 = [-0.5, 0.5];
mean2 = [1.5, 2.8];
mean3 = [1.8, -0.9];
mean4 = [3.6, 2.3];

prob = zeros(N,J);

probErr = zeros(maxIter,J);
meanErr = zeros(maxIter,J);
covErr = zeros(maxIter,J);
bayErr = zeros(maxIter,1);
iter = [1:maxIter];

disp(['Expectation-Maximazation algorithm for ',num2str(maxIter),' loops']);

for k=1:maxIter
     
% E-step
    for i=1:N
        denom = p(1)*gaussianPdf(data(i,:),mean1,S) + p(2)*gaussianPdf(data(i,:),mean2,S)+ p(3)*gaussianPdf(data(i,:),mean3,S) + p(4)*gaussianPdf(data(i,:),mean4,S) ;
        prob(i,1) = p(1)*gaussianPdf(data(i,:),mean1,S)/denom;
        prob(i,2) = p(2)*gaussianPdf(data(i,:),mean2,S)/denom;
        prob(i,3) = p(3)*gaussianPdf(data(i,:),mean3,S)/denom;
        prob(i,4) = p(4)*gaussianPdf(data(i,:),mean4,S)/denom;
    end
    
% M-step

% class conditional probability
    p = [0, 0, 0, 0];
    for i=1:N
        for j=1:J
            p(j) = p(j) + prob(i,j);
        end
    end
    p = p/N;
    
% mean
    mean1 = [0 0]; mean2 = [0 0];
    mean3 = [0 0]; mean4 = [0 0];
    num = [0 0 ; 0 0 ; 0 0 ; 0 0]; den = [0 0 0 0];
    for i=1:N
        for j=1:J
            num(j,:) = num(j,:) + prob(i,j)*data(i,:);
            den(j) = den(j) + prob(i,j);
        end
    end
    mean1 = num(1,:)/den(1);
    mean2 = num(2,:)/den(2);
    mean3 = num(3,:)/den(3);
    mean4 = num(4,:)/den(4);
    
% berore we start the next loop we calculate the errors
% of the probabilities, means and covarience matrices
    probErr(k,1) = norm(p(1)-P(1))/norm(P(1)); 
    probErr(k,2) = norm(p(2)-P(2))/norm(P(2));
    probErr(k,3) = norm(p(3)-P(3))/norm(P(3)); 
    probErr(k,4) = norm(p(4)-P(4))/norm(P(4));

    meanErr(k,1) = norm(m1-mean1)/norm(m1);
    meanErr(k,2) = norm(m2-mean2)/norm(m2);
    meanErr(k,3) = norm(m3-mean3)/norm(m3);
    meanErr(k,4) = norm(m4-mean4)/norm(m4);
        
% we also need to calculate the number of errors the 
% bayesian classifier gives us
    % bayesian method for the data
    g1 = zeros(n,J);
    g2 = zeros(n,J);
    
    c = -0.5*l*log(2*pi)-0.5*log(det(S));

    for i=1:n
      g1(i,1) = -0.5*((data1(i,:)-mean1)/S) *(data1(i,:)-mean1)' + log(p(1)) + c;
      g1(i,2) = -0.5*((data1(i,:)-mean2)/S) *(data1(i,:)-mean2)' + log(p(2)) + c;
      g1(i,3) = -0.5*((data1(i,:)-mean3)/S) *(data1(i,:)-mean3)' + log(p(3)) + c;
      g1(i,4) = -0.5*((data1(i,:)-mean4)/S) *(data1(i,:)-mean4)' + log(p(4)) + c;

      g2(i,1) = -0.5*((data2(i,:)-mean1)/S) *(data2(i,:)-mean1)' + log(p(1)) + c;
      g2(i,2) = -0.5*((data2(i,:)-mean2)/S) *(data2(i,:)-mean2)' + log(p(2)) + c;
      g1(i,3) = -0.5*((data1(i,:)-mean3)/S) *(data1(i,:)-mean3)' + log(p(3)) + c;
      g1(i,4) = -0.5*((data1(i,:)-mean4)/S) *(data1(i,:)-mean4)' + log(p(4)) + c;

    end

    errors = 0;

    for i=1:n
       if (find_max_pos(g1(i,:))~= 1 && find_max_pos(g1(i,:))~= 2)
           errors = errors + 1;
       end
       if (find_max_pos(g2(i,:))~= 3 && find_max_pos(g1(i,:))~= 4)
           errors = errors + 1;
       end
    end
    bayErr(k,1) = errors;
    
end

% plot the bayesian error-iteration diagramm for the two classes
figure(7);
plot(iter,bayErr);
title('Bayesian classifier errors');
xlabel(['iterations = 0,1,...,',num2str(maxIter)]);
ylabel('errors');

disp('Press any key to continue');
pause;
clc;
