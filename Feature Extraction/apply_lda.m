%% Linear Discriminant Analysis
% Apply linear discriminant analysis to the data extracted from gestures 

%initialize class structs
class(1).name = 'vattene';
class(2).name = 'vienqui';
class(3).name = 'perfetto';
class(4).name = 'furbo';
class(5).name = 'cheduepalle';
class(6).name = 'chevuoi';
class(7).name = 'daccordo';
class(8).name = 'seipazzo';
class(9).name = 'combinato';
class(10).name = 'freganiente';
class(11).name = 'ok';
class(12).name = 'costatifrei';
class(13).name = 'basta';
class(14).name = 'prendere';
class(15).name = 'noncenepiu';
class(16).name = 'fame';
class(17).name = 'tantotempo';
class(18).name = 'buonissimo';
class(19).name = 'messidaccordo';
class(20).name = 'sonostufo';
class(21).name = 'unknown';
class(1).coeff = [];
class(2).coeff = [];
class(3).coeff = [];
class(4).coeff = [];
class(5).coeff = [];
class(6).coeff = [];
class(7).coeff = [];
class(8).coeff = [];
class(9).coeff = [];
class(10).coeff = [];
class(11).coeff = [];
class(12).coeff = [];
class(13).coeff = [];
class(14).coeff = [];
class(15).coeff = [];
class(16).coeff = [];
class(17).coeff = [];
class(18).coeff = [];
class(19).coeff = [];
class(20).coeff = [];
class(21).coeff = [];

%% Data analysis
% go through all the files in Coefficient folder
files = dir('Coeffs_in_mat/*.mat');
for file = files'
    fname = sprintf('Coeffs_in_mat/%s',file.name);
    cmat = load(fname);
    class(cmat.class).coeff = [class(cmat.class).coeff; cmat.cmtx];
    
    sprintf('Processed file %s',file.name);
    % Do some stuff
end
% class(1).coeff = [4 1; 2 8 ; 6 3 ; 3 6 ; 4 4]
% class(2).coeff = [ 4 10; 6 8; 9 5; 9 7; 7 9 ]


%% Apply Fisher's Linear Discriminant Analysis for C = 20 classes

C = 20;                                                                     % number of classes
%  
% C = 2;

% 1. mean values
m = zeros(C + 1,size(class(1).coeff,2));
mall = zeros(1,size(class(1).coeff,2));                                     % the median value across all observations
Nall = 0;                                                                   % all observations in each of the 20 classes
for i= 1:C
    
    % get dimensions of class observations
    [N,M] = size(class(i).coeff);
    Nall = Nall + N;
    
    for j= 1:N
        m(i,:) = m(i,:) + class(i).coeff(j,:);
        mall(1,:) = mall(1,:) + class(i).coeff(j,:);
    end
    
    m(i,:) = m(i,:)/N;
end

mall(1,:) = mall(1,:)/Nall;                                                 % the median value across all observations

% 2. Covariance Matrices
S = cell(1, C);

for i= 1:C

    [N,M] = size(class(i).coeff);
    S{i} = zeros(M,M);
    
    for j= 1:N
        S{i} = S{i} + (class(i).coeff(j,:) - m(i,:))'*(class(i).coeff(j,:) - m(i,:)); 
    end
    
    S{i} = S{i}/(N-1);                                                      %% sample mean
end

% 3. Within Class Scatter and Between class Scatter matrices
Sb = zeros(M,M);                                                            % Between class scatter 
Sw = zeros(M,M);                                                            % Within Class scatter
for i= 1:C
    
    Sw = Sw + S{i};
    Sb = Sb + (m(i,:) - mall(1,:))'*(m(i,:) - mall(1,:));                  %% !! I have no idea why this happens .... !! size(class(i).coeff,1)*
end
Sb = C*Sb;

% 4. Total Scatter
St = Sb + Sw;

% 5. Compute eigenvectors and eigevalues
G = inv(Sw)*Sb;
%G = Sw\Sb;
[evector, evalue] = eig(G);

% find max eigenvalues
max = zeros(39,1);                                                          % we want to do a projection on the 39th dimensional space
pos = zeros(39,1);
for i=1:size(evalue,1)
    
    tmp = evalue(i,i);
    tmpi = i;
    for j=1:39
        % if the entry is bigger we substitute it with  the lesser value
        if tmp > max(j,:)
            
            % keep tmp copy of prev cell
            tmp2 = max(j,:);
            tmp2i = pos(j,:);
            
            % substitute
            pos(j,:) = tmpi;
            max(j,:) = tmp;
            
            % continue computation to place the remaining cell
            tmp = tmp2;
            tmpi = tmp2i;
        end
    end
end
max
pos

fin_vec = zeros(M,19);
% take the appropriate eigenvalues
for i=1:19                                                                  % normally we would like 39 but after testing the dataset can be cast effectively in the 19th dim space
    fin_vec(:,i) = evector(:,pos(i));
end

disp('- LDA Analysis Completed -');

%% Apply the transformation to the dataset

fname = sprintf('Coeffs_in_text/AllSamples_afterLDA.txt');
fileID = fopen(fname,'w');

% go through all the files in Coefficient folder
files = dir('Coeffs_in_mat/*.mat');
for file = files'
    fname = sprintf('Coeffs_in_mat/%s',file.name);
    cmat = load(fname);
    
    %class(cmat.class).coeff = [class(cmat.class).coeff; cmat.cmtx];
   
    
    
    projdata = (class(cmat.class).coeff)*fin_vec;
    
    for j= 1:size(projdata,1)
        for k= 1:size(projdata,2)
            
        end
    end
    
    sprintf('Processed file %s',file.name);
    % Do some stuff

end





