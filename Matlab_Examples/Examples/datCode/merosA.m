%%  MEROS A
%% Estw 4 isoppi9anes klaseis, ù1,ù2,ù3 kai ù4 (P(ùi)=1/4), me dianysmata
%% xarakthristikwn se dyo diastaseis (xåR^2) pou akolou9oun gia ka9e klash 
%% 2-D Gaussian katanomes p(x|ùi) me meses times m1 = [0, 0], m2 = [2 2],
%% m3 = [2 0], m4 = [4 2], adistoixa kai koina diagwnio mhtrwo
%% syndiasporas, iso me S = [0.6, 0.0 ; 0.0, 0.6]. Sth synexeia:
%%
diary on;
clear; clc;
disp('MEROS A');
pause;
clc;

%% A.1
%% Dhmiourghste ena synolo ekpaideushs me apiblepsh pou apoteleitai apo
%% N = 1000 shmeia xn ston xwro R^2 pou "phgazoun" apo tis parapanw 4
%% klaseis kai katanomes. Xrhsimopoihste gia ton skopo auto thn edolh
%% mvnrnd tou Matlab me katallhlh parallagh kai parametrous. Xrhsimh einai
%% epishs h arxikopoihsh ths gennhtrias tyxaiwn ari9mwn me sygkekrimeno
%% tropo, p.x. me thn edolh rand('seed',0), wste na einai efikth h
%% apanalhpsh tou peiramatos kai anaparagwgh twn apotelesmatwn
%%

disp('Meros A.1/A.2');
disp('------------');

p = [0.25, 0.25, 0.25, 0.25];
l = 2; M = 4; N = 1000; n = N/4;
randn('seed',0);

MU1 = [0,0]; MU2 = [2,2]; MU3 = [2,0]; MU4 = [4,2];
SIGMA = [0.6 0.0 ; 0.0 0.6];
r1 = mvnrnd(MU1,SIGMA,n);
r2 = mvnrnd(MU2,SIGMA,n);
r3 = mvnrnd(MU3,SIGMA,n);
r4 = mvnrnd(MU4,SIGMA,n);

%% A.2
%% Sxediaste ta dedomena ston 2-D xwro. Xrhsimopoihste diaforetikes 
%% "etiketes" (labels)sto diagramma gia ka9e klash.
%%

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

disp('Press any key to continue');
pause;
clc;

%% A.3
%% Apo ta dedomena xn tou synolou pou anhkoun sthn ka9e klash, ektimhste
%% tis meses times kai mhtrwa syndiasporas  twn 4 ypo syn9hkh synarthsewn
%% pyknothtas pi9anothtas, xrhsimopoiwdas ektimhsh megisths pi9anofaneias
%% (maximum likelihood estimation)
%%

disp('Meros A.3');
disp('------------');
disp('Mean and covarince based on maximum likelihood estimation');

m1 = [0,0]; m2 = [0,0]; m3 = [0,0]; m4 = [0,0];
for i=1:n
    m1 = m1 + r1(i,:);
    m2 = m2 + r2(i,:);
    m3 = m3 + r3(i,:);
    m4 = m4 + r4(i,:);
end

disp('Mean for class ù1 :');
m1 = m1/n
disp('Mean for class ù2 :');
m2 = m2/n
disp('Mean for class ù3 :');
m3 = m3/n
disp('Mean for class ù4 :');
m4 = m4/n

S1 = [0,0;0,0]; S2 = [0,0;0,0]; S3 = [0,0;0,0]; S4 = [0,0;0,0];
for i=1:n
    S1 = S1 + (r1(i,:) - m1)' * (r1(i,:) - m1);
    S2 = S2 + (r2(i,:) - m2)' * (r2(i,:) - m2);
    S3 = S3 + (r3(i,:) - m3)' * (r3(i,:) - m3);
    S4 = S4 + (r4(i,:) - m4)' * (r4(i,:) - m4);
end

disp('Covarience matrix for class ù1 :');
S1 = S1/n
disp('Covarience matrix for class ù2 :');
S2 = S2/n
disp('Covarience matrix for class ù3 :');
S3 = S3/250
disp('Covarience matrix for class ù4 :');
S4 = S4/n

disp('Press any key to continue');
pause;
clc;

%% A.4
%% Ta3inomhste ta dedomena xn tou synolou ekpaideushs stis 4 klaseis me
%% bash ton ta3inomhth eukleideias apostashs, xrhsimopoiwdas tis ektimhseis
%% twn parametrwn twn p(x|ùi) apo to Bhma A.3. Ypologiste to la9os
%% ta3inomhshs (%), sygkinodas tis apofaseis tou ta3inomhth me tis etikites
%% twn dedomenwn (apo to Bhma A.1).
%%

disp('Meros A.4');
disp('------------');

% euclidean method for the data
disp('Euclidean method for the data');

norms1 = zeros(n,M);
norms2 = zeros(n,M);
norms3 = zeros(n,M);
norms4 = zeros(n,M);

for i=1:n
  norms1(i,1) = norm(r1(i,:)-m1,2);
  norms1(i,2) = norm(r1(i,:)-m2,2);
  norms1(i,3) = norm(r1(i,:)-m3,2);
  norms1(i,4) = norm(r1(i,:)-m4,2);
  
  norms2(i,1) = norm(r2(i,:)-m1,2);
  norms2(i,2) = norm(r2(i,:)-m2,2);
  norms2(i,3) = norm(r2(i,:)-m3,2);
  norms2(i,4) = norm(r2(i,:)-m4,2);
  
  norms3(i,1) = norm(r3(i,:)-m1,2);
  norms3(i,2) = norm(r3(i,:)-m2,2);
  norms3(i,3) = norm(r3(i,:)-m3,2);
  norms3(i,4) = norm(r3(i,:)-m4,2);
  
  norms4(i,1) = norm(r4(i,:)-m1,2);
  norms4(i,2) = norm(r4(i,:)-m2,2);
  norms4(i,3) = norm(r4(i,:)-m3,2);
  norms4(i,4) = norm(r4(i,:)-m4,2);
end

errors = 0;

for i=1:n
   if (find_min_pos(norms1(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_min_pos(norms2(i,:))~= 2)
       errors = errors + 1;
   end
   if (find_min_pos(norms3(i,:))~= 3)
       errors = errors + 1;
   end
   if (find_min_pos(norms4(i,:))~= 4)
       errors = errors + 1;
   end
end

disp('Euclidean method for the pca data gives error (%) :');
(errors/N)*100

disp('Press any key to continue');
pause;
clc;

%% A.5
%% Epanalabete to peirama xrhsimopoiwdas ton ta3inomhth Mahalanobis
%% apostashs, xrhsimopoiwdas tis ektimhseis twn parametrwn p(x|ùi) apo to
%% Bhma A.3. Eidika gia ton pinaka syndiasporas, xrhsimopoihste enan koino
%% pinaka S ws ton sta9mismeno meso twn ektimhsewn twn mhtrwwn syndiasporas
%% tou Bhmatos A.3 gia tis 4 klaseis. Ypologiste to la9os ta3inomhshs kai
%% sxoliaste to apotelesma se sxesh me auto tou bhmatos A.4.
%%

disp('Meros A.5');
disp('------------');

% mahalanobis method for the data
disp('Mahalanobis method for the data');

S = p(1)*S1 + p(2)*S2 + p(3)*S3 + p(4)*S4;

mahalanobis1 = zeros(n,M);
mahalanobis2 = zeros(n,M);
mahalanobis3 = zeros(n,M);
mahalanobis4 = zeros(n,M);

for i=1:n
  mahalanobis1(i,1) = sqrt(((r1(i,:)-m1)/S) *(r1(i,:)-m1)');
  mahalanobis1(i,2) = sqrt(((r1(i,:)-m2)/S) *(r1(i,:)-m2)');
  mahalanobis1(i,3) = sqrt(((r1(i,:)-m3)/S) *(r1(i,:)-m3)');
  mahalanobis1(i,4) = sqrt(((r1(i,:)-m4)/S) *(r1(i,:)-m4)');
  
  mahalanobis2(i,1) = sqrt(((r2(i,:)-m1)/S) *(r2(i,:)-m1)');
  mahalanobis2(i,2) = sqrt(((r2(i,:)-m2)/S) *(r2(i,:)-m2)');
  mahalanobis2(i,3) = sqrt(((r2(i,:)-m3)/S) *(r2(i,:)-m3)');
  mahalanobis2(i,4) = sqrt(((r2(i,:)-m4)/S) *(r2(i,:)-m4)');
  
  mahalanobis3(i,1) = sqrt(((r3(i,:)-m1)/S) *(r3(i,:)-m1)');
  mahalanobis3(i,2) = sqrt(((r3(i,:)-m2)/S) *(r3(i,:)-m2)');
  mahalanobis3(i,3) = sqrt(((r3(i,:)-m3)/S) *(r3(i,:)-m3)');
  mahalanobis3(i,4) = sqrt(((r3(i,:)-m4)/S) *(r3(i,:)-m4)');
  
  mahalanobis4(i,1) = sqrt(((r4(i,:)-m1)/S) *(r4(i,:)-m1)');
  mahalanobis4(i,2) = sqrt(((r4(i,:)-m2)/S) *(r4(i,:)-m2)');
  mahalanobis4(i,3) = sqrt(((r4(i,:)-m3)/S) *(r4(i,:)-m3)');
  mahalanobis4(i,4) = sqrt(((r4(i,:)-m4)/S) *(r4(i,:)-m4)');
end

errors = 0;

for i=1:n
   if (find_min_pos(mahalanobis1(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_min_pos(mahalanobis2(i,:))~= 2)
       errors = errors + 1;
   end
   if (find_min_pos(mahalanobis3(i,:))~= 3)
       errors = errors + 1;
   end
   if (find_min_pos(mahalanobis4(i,:))~= 4)
       errors = errors + 1;
   end
end

disp('Mahalanobis method for the pca data gives error (%) :');
(errors/N)*100

disp('Press any key to continue');
pause;
clc;

%% A.6
%% Epanalabete xrhsimopoiwdas ton Bayesian ta3inomhth, me bash kai pali tis
%% ektimhseis twn parametrwn twn p(x|ùi) tou Bhmatos A.3. En adi9esei me to
%% Bhma A.5, xrhsimopoihste tis ektimhseis tou pinaka syndiasporas gia ka9e
%% klash 3exwrista. Ypologiste to la9os ta3inomhshs kai sxoliaste to
%% apotelesma se sxesh me auta twn Bhmatwn A.4 kai A.5.
%%

disp('Meros A.6');
disp('------------');

% bayesian method for the data
disp('Bayesian method for the data');

g1 = zeros(n,M);
g2 = zeros(n,M);
g3 = zeros(n,M);
g4 = zeros(n,M);

c = zeros(1,4);
c(1) = -0.5*l*log(2*pi)-0.5*log(det(S1));
c(2) = -0.5*l*log(2*pi)-0.5*log(det(S2));
c(3) = -0.5*l*log(2*pi)-0.5*log(det(S3));
c(4) = -0.5*l*log(2*pi)-0.5*log(det(S4));

for i=1:n
  g1(i,1) = -0.5*((r1(i,:)-m1)/S1) *(r1(i,:)-m1)' + log(p(1)) + c(1);
  g1(i,2) = -0.5*((r1(i,:)-m2)/S2) *(r1(i,:)-m2)' + log(p(2)) + c(2);
  g1(i,3) = -0.5*((r1(i,:)-m3)/S3) *(r1(i,:)-m3)' + log(p(3)) + c(3);
  g1(i,4) = -0.5*((r1(i,:)-m4)/S4) *(r1(i,:)-m4)' + log(p(4)) + c(4);

  g2(i,1) = -0.5*((r2(i,:)-m1)/S1) *(r2(i,:)-m1)' + log(p(1)) + c(1);
  g2(i,2) = -0.5*((r2(i,:)-m2)/S2) *(r2(i,:)-m2)' + log(p(2)) + c(2);
  g2(i,3) = -0.5*((r2(i,:)-m3)/S3) *(r2(i,:)-m3)' + log(p(3)) + c(3);
  g2(i,4) = -0.5*((r2(i,:)-m4)/S4) *(r2(i,:)-m4)' + log(p(4)) + c(4);

  g3(i,1) = -0.5*((r3(i,:)-m1)/S1) *(r3(i,:)-m1)' + log(p(1)) + c(1);
  g3(i,2) = -0.5*((r3(i,:)-m2)/S2) *(r3(i,:)-m2)' + log(p(2)) + c(2);
  g3(i,3) = -0.5*((r3(i,:)-m3)/S3) *(r3(i,:)-m3)' + log(p(3)) + c(3);
  g3(i,4) = -0.5*((r3(i,:)-m4)/S4) *(r3(i,:)-m4)' + log(p(4)) + c(4);

  g4(i,1) = -0.5*((r4(i,:)-m1)/S1) *(r4(i,:)-m1)' + log(p(1)) + c(1);
  g4(i,2) = -0.5*((r4(i,:)-m2)/S2) *(r4(i,:)-m2)' + log(p(2)) + c(2);
  g4(i,3) = -0.5*((r4(i,:)-m3)/S3) *(r4(i,:)-m3)' + log(p(3)) + c(3);
  g4(i,4) = -0.5*((r4(i,:)-m4)/S4) *(r4(i,:)-m4)' + log(p(4)) + c(4);

end

errors = 0;

for i=1:n
   if (find_max_pos(g1(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_max_pos(g2(i,:))~= 2)
       errors = errors + 1;
   end
   if (find_max_pos(g3(i,:))~= 3)
       errors = errors + 1;
   end
   if (find_max_pos(g4(i,:))~= 4)
       errors = errors + 1;
   end
end

disp('Bayesian method for the pca data gives error (%) :');
(errors/N)*100

disp('Press any key to exit');
pause;
clc;
diary off;
