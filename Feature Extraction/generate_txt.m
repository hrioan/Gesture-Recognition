%% generate txt coeff files
%% Apply the transformation to the dataset

% How many features we wish to extract
dimesionality = 52;%78;

% How many consecutive frames (from the beginning) we wish to extract
pref_frames = 60; 

% Initialization of .txt files
fname = sprintf('Coeffs_in_text/Train_data.txt');
fileID = fopen(fname,'w');

fname2 = sprintf('Coeffs_in_text/Test_data.txt');
fileID2 = fopen(fname2,'w');

% silences and pauses ( discrimination btw silences and pauses) 
silno = 0;
pno = 0;

% Go through all the files in Coefficient folder
files = dir('Coeffs_in_mat/*.mat');
for file = files'
    fname = sprintf('Coeffs_in_mat/%s',file.name);
    cmat = load(fname);
    
    %class(cmat.class).coeff = [class(cmat.class).coeff; cmat.cmtx];
%     projdata = zeros(size(cmat.cmtx,1),size(cmat.cmtx,2));
%     for i=1:size(cmat.cmtx,1)
%         projdata(i,:) = cmat.cmtx(i,:) - m(cmat.class); 
%     end

    projdata = (cmat.cmtx(:,1:dimesionality));
    
    nframes = min(pref_frames,size(projdata,1));
    
    if strcmp(file.name(1),'I') == 1                                        % -- Test Dataset --
%            
%         fprintf(fileID2,'%s [ \n', strtok(file.name,'.'));
%         for j= 1:3:size(projdata,1)
%             for k= 1:size(projdata,2)
%                 fprintf(fileID2,'%f ',projdata(j,k));
%             end
%             fprintf(fileID2,'\n ');
%         end
%         fprintf(fileID2,']\n ');
    elseif strcmp(file.name(1),'T') == 1                                    % -- Train Dataset --
        
        fprintf(fileID,'%s [ \n', strtok(file.name,'.'));
        for j= 1:3:size(projdata,1)
            for k= 1:size(projdata,2)
                fprintf(fileID,'%f ',projdata(j,k));
            end
            fprintf(fileID,'\n ');
        end
        fprintf(fileID,']\n ');
    else
                                                                            % -- Silence Samples --
        
        % Check to see how many frames in each sequence
        if (size(cmat.cmtx,1) < 15 && size(cmat.cmtx,1) > 4)                                           % -- a. Short Pause --
            
            %silname = strcat('SP_',strtok(file.name,'.'));
            silname = sprintf('Sb%03d',pno);
            
            % create txt files
            fname = sprintf('Coeffs_in_text/%s.txt',silname);
            fileIDSP = fopen(fname,'w');
            fclose(fileIDSP);
            
            fprintf(fileID,'%s [ \n', silname);
            for j= 1:size(projdata,1)
                for k= 1:size(projdata,2)
                    fprintf(fileID,'%f ',projdata(j,k));
                end
                fprintf(fileID,'\n ');
            end
            fprintf(fileID,']\n ');
            
            pno = pno + 1;
            
        elseif (size(cmat.cmtx,1) <= 4)
            
            %silname = strcat('Sa_',strtok(file.name,'.'));
            silname = sprintf('Sa%03d',pno);
            
            % create txt files
            fname = sprintf('Coeffs_in_text/%s.txt',silname);
            fileIDSP = fopen(fname,'w');
            fclose(fileIDSP);
            
            fprintf(fileID,'%s [ \n', silname);
            for j= 1:size(projdata,1)
                for k= 1:size(projdata,2)
                    fprintf(fileID,'%f ',projdata(j,k));
                end
                fprintf(fileID,'\n ');
            end
            fprintf(fileID,']\n ');
            
            pno = pno + 1;
            disp('--YEAH1!!---');
        elseif (size(cmat.cmtx,1) < 30 && size(cmat.cmtx,1) > 15)
            %silname = strcat('Sa_',strtok(file.name,'.'));
            silname = sprintf('Sc%03d',pno);
            
            % create txt files
            fname = sprintf('Coeffs_in_text/%s.txt',silname);
            fileIDSP = fopen(fname,'w');
            fclose(fileIDSP);
            
            fprintf(fileID,'%s [ \n', silname);
            for j= 1:size(projdata,1)
                for k= 1:size(projdata,2)
                    fprintf(fileID,'%f ',projdata(j,k));
                end
                fprintf(fileID,'\n ');
            end
            fprintf(fileID,']\n ');
            
            pno = pno + 1;
            disp('--YEAH1!!---');
        else
            
        silname = sprintf('Sil%05d',silno);
            
        fname = sprintf('Coeffs_in_text/%s.txt',silname);
            fileIDSP = fopen(fname,'w');
            fclose(fileIDSP);
            
        fprintf(fileID,'%s [ \n', silname);
        for j= 1:size(projdata,1)
            for k= 1:size(projdata,2)
                fprintf(fileID,'%f ',projdata(j,k));
            end
            fprintf(fileID,'\n ');
        end
        fprintf(fileID,']\n ');
        
        silno = silno + 1;
        
        end
        
        
    end
    
    sprintf('End processing file %s',file.name);
end
disp('ApplyLDA Completed');