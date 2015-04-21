%%  MEROS D
%%  
%% Epanerxeste sto meros B, dhladh stis 4 isopi9anes klaseis me ypo syn9hkh
%% synarthsh pyknothtas pi9anothtas twn xarakthristikwn pou einai 2D 
%% Gaussians me meses times ths e3iswshs (1) kai koina, mh diagwnia mhtrwa
%% syndiasporas ths e3iswshs (3). Sto meros auto ths ergasias 9a 9ewrhsete 
%% oti exete dyo klaseis pou prokyptoun apo thn enwsh twn prohgoumenwn
%% klasewn, kai 9a ta3inomhsete ta dedomena xrhsimopoiwdas thn probolh tous
%% se katallhlh eu9eia, me bash tous metasxhmatismous PCA kai LDA. Gia ton
%% skopo auto:
%%
diary on;
clear; clc;
disp('MEROS D');
pause;
clc;

%% D.1
%% Opws kai sta prohgoumena merh, dhmiourghste to synolo ekpaideushs 1000
%% shmeiwn, pou "phgazoun" apo tis 4 klaseis kai katanomes
%%

disp('Meros D.1');
disp('------------');

p = [0.5, 0.5];
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
legend('class �1','class �2','class �3','class �4');

disp('Press any key to continue');
pause;
clc;

%% D.2
%% Syndyaste tis klaseis se dyo, dhladh thn �1 = �1U�2 kai �2=�3U�4
%%

disp('Meros D.2/D.3');
disp('------------');

data1 = fusion(r1,r2);
data2 = fusion(r3,r4);

M = 2; n = N/2;

%% D.3 
%% Sxediaste ta dedomena twn dyo klasewn ston 2-D xwro
%%

figure(2);
plot(data1(:,1),data1(:,2),'b+');
hold on;
plot(data2(:,1),data2(:,2),'r+');
legend('class �1','class �2');

disp('Figure2 shows the data for the fusioned classes');

disp('Press any key to continue');
pause;
clc;

%% D.4
%% 9ewrhste oti oi dyo klaseis modelopoioudai me mia 2-D Gaussian h ka9e
%% mia (dhladh h ypo syn9hkh synarthsh pyknothtas pi9anothtas twn 
%% xarakthristikwn do9eishs ths klashs). Ypologiste sthn synexeia tis meses
%% times kai mhtrwa syndiasporas twn dyo gaussians xrhsimopoiwdas ektimhsh
%% megisths pi9anofaneias
%%

disp('Meros D.4');
disp('------------');

disp('Mean and covarince based on maximum likelihood estimation');

m1 = [0,0]; m2 = [0,0];
for i=1:n
    m1 = m1 + data1(i,:);
    m2 = m2 + data2(i,:);
end

disp('Mean for class �1 :');
m1 = m1/n
disp('Mean for class �2 :');
m2 = m2/n


S1 = [0,0;0,0]; S2 = [0,0;0,0]; 
for i=1:n
    S1 = S1 + (data1(i,:) - m1)' * (data1(i,:) - m1);
    S2 = S2 + (data2(i,:) - m2)' * (data2(i,:) - m2);
end

disp('Covarience matrix for class �1 :');
S1 = S1/n
disp('Covarience matrix for class �1 :');
S2 = S2/n

disp('Press any key to continue');
pause;
clc;

%% D.5
%% Ta3inomhste ta dedomena stis dyo klaseis me bash ton ta3inomhth 
%% eukleideias apostashs kai ton bayesian ta3inomhth. Se ka9e periptwsh,
%% ypologiste to sfalma ta3inomhshs (%)
%%

disp('Meros D.5');
disp('------------');

% euclidean method for the data
disp('Euclidean method for the data');

norms1 = zeros(500,M);
norms2 = zeros(500,M);

for i=1:n
  norms1(i,1) = norm(data1(i,:)-m1,2);
  norms1(i,2) = norm(data1(i,:)-m2,2);
  
  norms2(i,1) = norm(data2(i,:)-m1,2);
  norms2(i,2) = norm(data2(i,:)-m2,2);
end

errors = 0;

for i=1:n
   if (find_min_pos(norms1(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_min_pos(norms2(i,:))~= 2)
       errors = errors + 1;
   end
end

disp('Euclidean method for the data gives error (%) :');
(errors/N)*100


% bayesian method for the data
disp('Bayesian method for the data');

g1 = zeros(n,M);
g2 = zeros(n,M);

c = zeros(1,2);
c(1) = -0.5*l*log(2*pi)-0.5*log(det(S1));
c(2) = -0.5*l*log(2*pi)-0.5*log(det(S2));

for i=1:n
  g1(i,1) = -0.5*((data1(i,:)-m1)/S1) *(data1(i,:)-m1)' + log(p(1)) + c(1);
  g1(i,2) = -0.5*((data1(i,:)-m2)/S2) *(data1(i,:)-m2)' + log(p(2)) + c(2);

  g2(i,1) = -0.5*((data2(i,:)-m1)/S1) *(data2(i,:)-m1)' + log(p(1)) + c(1);
  g2(i,2) = -0.5*((data2(i,:)-m2)/S2) *(data2(i,:)-m2)' + log(p(2)) + c(2);
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

disp('Bayesian method for the data gives error (%) :');
(errors/N)*100

disp('Press any key to continue');
pause;
clc;

%% D6
%% Sth synexeia, breite thn monodiastath probolh twn dedomenwn tou synolou
%% ekpaideushs kata mhkos tou idiodianysmatos pou adistoixh sthn megalyterh
%% idiotimh me bash ton metasxhmatismo PCA. Sxediaste ta shmeia pou
%% prokyptoun. Ti parathreite;
%%

disp('Meros D.6');
disp('------------');

% STEP 1 : substract the mean
adjustData1 = zeros(n,M);
adjustData2 = zeros(n,M);
for i=1:n
    adjustData1(i,:) = data1(i,:) - m1;
    adjustData2(i,:) = data2(i,:) - m2;
end

% STEP 2 : calculate the the covarience matrix
R1 = [0,0;0,0]; R2 = [0,0;0,0]; 
for i=1:n
    R1 = R1 + adjustData1(i,:)' * adjustData1(i,:);
    R2 = R2 + adjustData2(i,:)' * adjustData2(i,:);
end
R1 = R1/n;
R2 = R2/n;

% STEP 3 : calculate the eigenvectors and the eigenvalues of the covarience
%          matrix
[V1,D1] = eig(R1);
[V2,D2] = eig(R2);

% STEP 4 : choosing components and forming a feature vector
A1 = eigenSort(D1,V1);
A2 = eigenSort(D2,V2);

% STEP 5 : deriving the new data set
newData1 = zeros(500,2);
newData2 = zeros(500,2);

lala = pca(adjustData1)

for i=1:n
%     newData1(i,:) = (lala(:,1))' * adjustData1(i,:)' ;
%     newData2(i,:) = (lala(:,1))' * adjustData2(i,:)' ;
    newData1(i,:) = (A1(:,1))' * adjustData1(i,:)' ;
    newData2(i,:) = (A2(:,1))' * adjustData2(i,:)' ;
end

disp('Figure3 demonstrates the projection of our data ');
disp('using the PCA trasform');

figure(3);
plot(data1(:,1),data1(:,2),'b+');
hold on;
plot(data2(:,1),data2(:,2),'r+');
hold on;
plot(newData1(:,1),newData1(:,2),'g+');
hold on;
plot(newData2(:,1),newData2(:,2),'g--o');
legend('class �1','class �2');

disp('Press any key to continue');
pause;
clc;

%% D.7
%% Ta3inomhste ta shmeia pou prokyptoun xrhsimopoiwdas ton monodiastato
%% ta3inomhth eukleideias apostashs kai ton bayesian ta3inomhth (gia
%% teleutaio xrhsimopoihste 1-D Gaussians gia ka9e klash). Ypologiste to
%% sfalma ta3inomhshs.
%%

disp('Meros D.7');
disp('------------');

% mean and variance for the pca data, based on likelihood
mean1=0; mean2=0;
for i=1:n
    mean1 = mean1 + newData1(i,1);
    mean2 = mean2 + newData2(i,1);
end
mean1 = mean1/500;
mean2 = mean2/500;

var1=0; var2=0;
for i=1:n
    var1 = (newData1(i,1)-mean1)^2;
    var2 = (newData2(i,1)-mean2)^2;
end
var1 = var1/n;
var2 = var2/n;

% euclidian method for the pca data
norms1 = zeros(n,M);
norms2 = zeros(n,M);

for i=1:n
  norms1(i,1) = norm(newData1(i,:)-mean1,2);
  norms1(i,2) = norm(newData1(i,:)-mean2,2);
  
  norms2(i,1) = norm(newData2(i,:)-mean1,2);
  norms2(i,2) = norm(newData2(i,:)-mean2,2);
end

errors = 0;

for i=1:n
   if (find_min_pos(norms1(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_min_pos(norms2(i,:))~= 2)
       errors = errors + 1;
   end
end

disp('Euclidean method for the pca data gives error (%) :')
(errors/N)*100

% bayesian method for the pca data
g1pca = zeros(n,M);
g2pca = zeros(n,M);

c = zeros(1,2);
c(1) = -0.5*log(2*pi)-0.5*log(var1);
c(2) = -0.5*log(2*pi)-0.5*log(var2);

for i=1:n
  g1pca(i,1) = norm(newData1(i,:)-mean1,2)/(2*var1) + log(p(1)) + c(1);
  g1pca(i,2) = norm(newData1(i,:)-mean2,2)/(2*var2) + log(p(2)) + c(2);

  g2pca(i,1) = norm(newData2(i,:)-mean1,2)/(2*var1) + log(p(1)) + c(1);
  g2pca(i,2) = norm(newData2(i,:)-mean2,2)/(2*var2) + log(p(2)) + c(2);
end

errors = 0;

for i=1:n
   if (find_max_pos(g1pca(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_max_pos(g2pca(i,:))~= 2)
       errors = errors + 1;
   end
end

disp('Bayesian method for the pca data gives error (%) :')
(errors/N)*100

disp('Press any key to continue');
pause;
clc;

%% D.8
%% Sth synexeia, breite pali thn monodiastath probolh twn dedomenwn tou
%% synolou ekpaideushs, alla auth th fora me bash ton metasxhmatismo LDA.
%% Sxediaste ta shmeia pou prokyptoun.Ti parathreite se sxesh me to 
%% bhma D.6; 
%%

disp('Meros D.8');
disp('------------');

Sw = p(1)*S1 + p(2)*S2;
w = Sw\((m1-m2)');

ldaData1 = zeros(n,M);
ldaData2 = zeros(n,M);

for i=1:n
    ldaData1(i,:) = w' * data1(i,:)' ;
    ldaData2(i,:) = w' * data2(i,:)' ;
end

ldaData1 = ldaData1/norm(w,2);
ldaData2 = ldaData2/norm(w,2);

disp('Figure4 demonstrates the projection of our data ');
disp('using the PCA trasform');

figure(4);
plot(data1(:,1),data1(:,2),'b+');
hold on;
plot(data2(:,1),data2(:,2),'r+');
hold on;
plot(-ldaData1(:,1),ldaData1(:,2),'b+');
hold on;
plot(-ldaData2(:,1),ldaData2(:,2),'r+');
legend('class �1','class �2');

disp('Press any key to continue');
pause;
clc;

%% D9
%% Ta3inomhste ta shmeia pou prokyptoun xrhsimopoiwdas ton monodiastato
%% ta3inomhth eukleideias apostashs kai ton bayesian ta3inomhth (gia ton
%% teleutaio xrhsimopoieiste 1-D Gaussians gia ka9e klash). Ypologiste to
%% sfalma ta3inomhshs. Ti parathreite se sxesh me to bhma D.7;
%%

disp('Meros D.9');
disp('------------');

% mean and variance for the lda data, based on likelihood
mean1=0; mean2=0;
for i=1:n
    mean1 = mean1 + ldaData1(i,1);
    mean2 = mean2 + ldaData2(i,1);
end
mean1 = mean1/n;
mean2 = mean2/n;

var1=0; var2=0;
for i=1:n
    var1 = (ldaData1(i,1)-mean1)^2;
    var2 = (ldaData2(i,1)-mean2)^2;
end
var1 = var1/n;
var2 = var2/n;

% euclidian method for the lda data
norms1 = zeros(n,M);
norms2 = zeros(n,M);

for i=1:n
  norms1(i,1) = norm(ldaData1(i,:)-mean1,2);
  norms1(i,2) = norm(ldaData1(i,:)-mean2,2);
  
  norms2(i,1) = norm(ldaData2(i,:)-mean1,2);
  norms2(i,2) = norm(ldaData2(i,:)-mean2,2);
end

errors = 0;

for i=1:n
   if (find_min_pos(norms1(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_min_pos(norms2(i,:))~= 2)
       errors = errors + 1;
   end
end

disp('Euclidean method for the pca data gives error (%) :')
(errors/N)*100

% bayesian method for the lda data
g1lda = zeros(n,M);
g2lda = zeros(n,M);

c = zeros(1,2);
c(1) = -0.5*log(2*pi)-0.5*log(var1);
c(2) = -0.5*log(2*pi)-0.5*log(var2);

for i=1:n
  g1lda(i,1) = norm(ldaData1(i,:)-mean1,2)/(2*var1) + log(p(1)) + c(1);
  g1lda(i,2) = norm(ldaData1(i,:)-mean2,2)/(2*var2) + log(p(2)) + c(2);

  g2lda(i,1) = norm(ldaData2(i,:)-mean1,2)/(2*var1) + log(p(1)) + c(1);
  g2lda(i,2) = norm(ldaData2(i,:)-mean2,2)/(2*var2) + log(p(2)) + c(2);
end

errors = 0;

for i=1:n
   if (find_max_pos(g1pca(i,:))~= 1)
       errors = errors + 1;
   end
   if (find_max_pos(g2pca(i,:))~= 2)
       errors = errors + 1;
   end
end

disp('Bayesian method for the pca data gives error (%) :')
(errors/N)*100

disp('Press any key to exit');
pause;
clc;

diary off;