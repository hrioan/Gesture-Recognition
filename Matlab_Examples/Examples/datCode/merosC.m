%% MEROS C
%% Epanalabete ta parapanw sth synexeia gia mh isopi9anes klaseis, kai
%% syglekrimena gia proteres (a-priori) pi9anothtes klasewn P(ù1) = 1/2,
%% P(ù2) = 1/16, P(ù3) = 1/16, P(ù4) = 3/8 (bhmata C.1-C.6). Isxyoun oi e3.
%% (1) (apo to Meros A) kai e3.(3) (apo to Meros B) gia tis meses times kai
%% ta mhtrwa syndiasporas adistoixa. Opws kai prin, sxoliaste tis
%% diaforopoihseis meta3y twn ta3inomhtwn Eukleideias apostashs, apostashs
%% Mahalanobis kai tou Bayesian ta3inomhthse sxesh me autes twn Merwn A kai
%% B ths ergasias.
%%
diary on;
clear; clc;
disp('MEROS C');
pause;
clc;

%% C.1
%%

disp('Meros C.1/C.2');
disp('------------');

p = [1/2, 1/16, 1/16, 3/8];
l = 2; M = 4; N = 1000; n = N/4;
randn('seed',0);

MU1 = [0,0]; MU2 = [2,2]; MU3 = [2,0]; MU4 = [4,2];
SIGMA = [0.6 0.4 ; 0.4 0.6];
r1 = mvnrnd(MU1,SIGMA,n);
r2 = mvnrnd(MU2,SIGMA,n);
r3 = mvnrnd(MU3,SIGMA,n);
r4 = mvnrnd(MU4,SIGMA,n);

%% C.2
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

%% C.3
%%

disp('Meros C.3');
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
S3 = S3/n
disp('Covarience matrix for class ù4 :');
S4 = S4/n

disp('Press any key to continue');
pause;
clc;

%% C.4
%%

disp('Meros C.4');
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

%% C.5
%%

disp('Meros C.5');
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

%% C.6
%%

disp('Meros C.6');
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