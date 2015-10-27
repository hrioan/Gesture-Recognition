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

% trolling in the deep 
class(21).name = 'vattene2';
class(22).name = 'vienqui2';
class(23).name = 'perfetto2';
class(24).name = 'furbo2';
class(25).name = 'cheduepalle2';
class(26).name = 'chevuoi2';
class(27).name = 'daccordo2';
class(28).name = 'seipazzo2';
class(29).name = 'combinato2';
class(30).name = 'freganiente2';
class(31).name = 'ok2';
class(32).name = 'costatifrei2';
class(33).name = 'basta2';
class(34).name = 'prendere2';
class(35).name = 'noncenepiu2';
class(36).name = 'fame2';
class(37).name = 'tantotempo2';
class(38).name = 'buonissimo2';
class(39).name = 'messidaccordo2';
class(40).name = 'sonostufo2';
class(21).coeff = [];
class(22).coeff = [];
class(23).coeff = [];
class(24).coeff = [];
class(25).coeff = [];
class(26).coeff = [];
class(27).coeff = [];
class(28).coeff = [];
class(29).coeff = [];
class(30).coeff = [];
class(31).coeff = [];
class(32).coeff = [];
class(33).coeff = [];
class(34).coeff = [];
class(35).coeff = [];
class(36).coeff = [];
class(37).coeff = [];
class(38).coeff = [];
class(39).coeff = [];
class(40).coeff = [];


% trolling in the deep 
class(41).name = 'vattene3';
class(42).name = 'vienqui3';
class(43).name = 'perfetto3';
class(44).name = 'furbo3';
class(45).name = 'cheduepalle3';
class(46).name = 'chevuoi3';
class(47).name = 'daccordo3';
class(48).name = 'seipazzo3';
class(49).name = 'combinato3';
class(50).name = 'freganiente3';
class(51).name = 'ok3';
class(52).name = 'costatifrei3';
class(53).name = 'basta3';
class(54).name = 'prendere3';
class(55).name = 'noncenepiu3';
class(56).name = 'fame3';
class(57).name = 'tantotempo3';
class(58).name = 'buonissimo3';
class(59).name = 'messidaccordo3';
class(60).name = 'sonostufo3';
class(41).coeff = [];
class(42).coeff = [];
class(43).coeff = [];
class(44).coeff = [];
class(45).coeff = [];
class(46).coeff = [];
class(47).coeff = [];
class(48).coeff = [];
class(49).coeff = [];
class(50).coeff = [];
class(51).coeff = [];
class(52).coeff = [];
class(53).coeff = [];
class(54).coeff = [];
class(55).coeff = [];
class(56).coeff = [];
class(57).coeff = [];
class(58).coeff = [];
class(59).coeff = [];
class(60).coeff = [];


class(61).name = 'silencio';
class(62).name = 'unknown';
class(61).coeff = [];
class(62).coeff = [];


%% Data analysis
% go through all the files in Coefficient folder
files = dir('Coeffs_in_mat/*.mat');
for file = files'
    fname = sprintf('Coeffs_in_mat/%s',file.name);
    cmat = load(fname);
    
    if strcmp(file.name(1),'I') == 1                                        % unknown
        continue;
    end
    if strcmp(file.name(1),'S') == 1                                        % Silencio kanonika 21
        class(61).coeff = [class(61).coeff; cmat.cmtx];
        fprintf('Processed file %s \n',file.name);
        continue;
    end
    
    %% split input into 3 modalities for better results
    disp('Edw oi kales blakeies....');
    [jn,jm] = size(cmat.cmtx)
    
    if jn < 3
        continue;
    end
    
    class(cmat.class).coeff = [class(cmat.class).coeff; cmat.cmtx(1:fix(jn/3),:)];
    class(cmat.class + 20).coeff = [class(cmat.class + 20).coeff; cmat.cmtx(fix(jn/3):fix(2*jn/3),:)];
    class(cmat.class + 40).coeff = [class(cmat.class + 40).coeff; cmat.cmtx(fix(2*jn/3):jn,:)];
    %% 
    
    %class(cmat.class).coeff = [class(cmat.class).coeff; cmat.cmtx];
    
    fprintf('Processed file %s \n',file.name);
    % Do some stuff
end
% class(1).coeff = [4 1; 2 8 ; 6 3 ; 3 6 ; 4 4]
% class(2).coeff = [ 4 10; 6 8; 9 5; 9 7; 7 9 ]
disp('Edw oi kales blakeies.... its over!!!');

%% Apply Fisher's Linear Discriminant Analysis for C = 20 classes

C = 60;
%C = 20;
%  
%C = 2;

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
max = zeros(C,1);                                                          % we want to do a projection on the 39th dimensional space 
pos = zeros(C,1);
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

pos
max

fin_vec = zeros(M,7);
% take the appropriate eigenvalues
for i=1:7                                                             % normally we would like 39 but after testing the dataset can be cast effectively in the 19th dim space
    fin_vec(:,i) = evector(:,pos(i));
end

disp('- LDA Analysis Completed -');
%pause;
%% Apply the transformation to the dataset

fname = sprintf('Coeffs_in_text/Train_data_afterLDA.txt');
fileID = fopen(fname,'w');

fname2 = sprintf('Coeffs_in_text/Test_data_afterLDA.txt');
fileID2 = fopen(fname2,'w');

% go through all the files in Coefficient folder
files = dir('Coeffs_in_mat/*.mat');
for file = files'
    fname = sprintf('Coeffs_in_mat/%s',file.name);
    cmat = load(fname);
    
    %class(cmat.class).coeff = [class(cmat.class).coeff; cmat.cmtx];
       

%     projdata = zeros(size(cmat.cmtx,1),size(cmat.cmtx,2));
%     for i=1:size(cmat.cmtx,1)
%         projdata(i,:) = cmat.cmtx(i,:) - m(cmat.class); 
%     end

    projdata = (cmat.cmtx)*fin_vec;
    
    if strcmp(file.name(1),'I') == 1                                        % -- Test Dataset --
           
        fprintf(fileID2,'%s [ \n', file.name(1:24));
        for j= 1:size(projdata,1)
            for k= 1:size(projdata,2)
                fprintf(fileID2,'%f ',projdata(j,k));
            end
            fprintf(fileID2,'\n ');
        end
        fprintf(fileID2,']\n ');
    elseif strcmp(file.name(1),'T') == 1                                    % -- Train Dataset --
        
        
        fprintf(fileID,'%s [ \n', file.name(1:24));
        for j= 1:size(projdata,1)
            for k= 1:size(projdata,2)
                fprintf(fileID,'%f ',projdata(j,k));
            end
            fprintf(fileID,'\n ');
        end
        fprintf(fileID,']\n ');
    else
        %% SILENCIO
        fprintf(fileID,'%s [ \n', file.name(1:13));
        for j= 1:size(projdata,1)
            for k= 1:size(projdata,2)
                fprintf(fileID,'%f ',projdata(j,k));
            end
            fprintf(fileID,'\n ');
        end
        fprintf(fileID,']\n ');
    end
    
    sprintf('End processing file %s',file.name);
end
disp('ApplyLDA Completed');




