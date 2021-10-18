% Obesity Classifier

% scan files
dirpath = 'Train_Textual';    %yourpath
files=dir(dirpath);
nf=length(files);

% define obese, remove and BMI words
obese_words = {'OBESE', 'OBESITY', 'OVERWIEGHT', 'Liposuction'};
obese_words2 = {'Gastric', 'bypass'};
obese_words3 = {'Gastric', 'partition'};
obese_words4 = {'Gastric', 'ballon'};
obese_words5 = {'Gastric', 'Plication'};
obese_words6 = {'Gastric', 'surgery'};
%rm_words = {'Abdomen', 'obese'}; 
BMI_words = {'feet', 'inches', 'kg'};
BMI_words2 = {'feet', 'inches', 'pounds'};

% initialize parameters
Filename = cell(nf-2, 1);
Obesity = zeros(nf-2, 1);
Obesity2 = zeros(nf-2, 1);
Obesity3 = zeros(nf-2, 1);
Obesity4 = zeros(nf-2, 1);
Obesity5 = zeros(nf-2, 1);
Obesity6 = zeros(nf-2, 1);
BMI_cal = zeros(nf-2, 1);
BMI_str = '';
obese_count = 0;
rm_count = 0;


for i=3:nf
    
    k = i-2;
    
    % open file
    filename = strcat(dirpath, '/', files(i).name);
    
    % split into sentences
    str = extractFileText(filename);          
    sentences = strsplit(str, '.');            %split the text to the sentences
    sentences = sentences';
    sentences = erasePunctuation(sentences);   %erase punctuation from sentences
    
    % detect obese words in every sentence
    for c = 1:length(sentences)
        symbolicseq = split(sentences(c, 1));  %split the sentence to the words
        
        for c2 = 1:length(symbolicseq)  

                match_1 = strcmpi(symbolicseq{c2}, obese_words);
                %match_2 = strcmpi(symbolicseq{c2}, rm_words);
                        
                if sum(match_1) > 0      
                    obese_count = obese_count + 1;
                end
                
                %if sum(match_2) > 0         
                %    rm_count = rm_count + 1;
                %end                   
                             
        end
        
        % Obesity status
        if obese_count > 0  % rm_count == 0
            Obesity(k,1) = 1;
        end
          
        % reset before the next sentence
        obese_count = 0; 
        %rm_count = 0;
            
    end   
    
    % BMI_word1 detector
    k1 = strfind(sentences, BMI_words(1,1));
    k2 = strfind(sentences, BMI_words(1,2));
    k3 = strfind(sentences, BMI_words(1,3));
    
    % replace arrays
    tf1 = cellfun('isempty', k1);  % true for empty cells
    k1(tf1) = {0};                 % put 0 in cells
    tf2 = cellfun('isempty', k2); 
    k2(tf2) = {0};
    tf3 = cellfun('isempty', k3); 
    k3(tf3) = {0};  
    for c3 = 1:length(sentences)
        if length(k1{c3, 1})>1
            k1{c3, 1} = 0;  %take out
        end
        if length(k2{c3, 1})>1
            k2{c3, 1} = 0;  
        end
        if length(k3{c3, 1})>1
            k3{c3, 1} = 0;  
        end
    end  
    k1 = cell2mat(k1);
    k2 = cell2mat(k2);
    k3 = cell2mat(k3);
       
    % detect BMI words in every sentence
    for c4 = 1:length(sentences)
      
        if k1(c4, 1) > 0 && k2(c4, 1) > 0 && k3(c4, 1) > 0
            BMI_str = sentences(c4, 1);
            newstr = split(BMI_str);        %split the sentence to the words
            m1 = strfind(newstr, BMI_words(1,1));
            m2 = strfind(newstr, BMI_words(1,2));
            m3 = strfind(newstr, BMI_words(1,3));
            
            % replace arrays
            tfm1 = cellfun('isempty', m1);  % true for empty cells
            tfm2 = cellfun('isempty', m2);  
            tfm3 = cellfun('isempty', m3);  
            m1(tfm1) = {0}; 
            m2(tfm2) = {0}; 
            m3(tfm3) = {0}; 
            m1 = cell2mat(m1);
            m2 = cell2mat(m2);
            m3 = cell2mat(m3);
            a1 = find(m1==1);
            a2 = find(m2==1);
            a3 = find(m3==1);
            
            % calculate BMI
            feet = str2double(newstr(a1-1, 1));
            inches = str2double(newstr(a2-1, 1));
            kg = str2double(newstr(a3-1, 1));
 
            if  kg >300
                kg = kg*0.1;
            end
            
            height = feet*0.3048 + inches*0.0254;
            weight = kg;
            
            BMI_cal(k,1) = weight/height^2;
            if(BMI_cal(k,1) > 30)
                Obesity(k,1) = 1;
            end
        end
    end
    
    % BMI_word2 detect
    k1 = strfind(sentences, BMI_words2(1,1));
    k2 = strfind(sentences, BMI_words2(1,2));
    k3 = strfind(sentences, BMI_words2(1,3));
    
    % replace arrays
    tf1 = cellfun('isempty', k1);  % true for empty cells
    k1(tf1) = {0};                 % put 0 in cells
    tf2 = cellfun('isempty', k2); 
    k2(tf2) = {0};
    tf3 = cellfun('isempty', k3); 
    k3(tf3) = {0};
    
    for c3 = 1:length(sentences)
        if length(k1{c3, 1})>1
            k1{c3, 1} = 0;  %take out
        end
        if length(k2{c3, 1})>1
            k2{c3, 1} = 0;  
        end
        if length(k3{c3, 1})>1
            k3{c3, 1} = 0;  
        end
    end
    
    k1 = cell2mat(k1);
    k2 = cell2mat(k2);
    k3 = cell2mat(k3);
    
    % detect BMI words in every sentence
    for c4 = 1:length(sentences)
      
        if k1(c4, 1) > 0 && k2(c4, 1) > 0 && k3(c4, 1) > 0
            BMI_str = sentences(c4, 1);
            newstr = split(BMI_str);        % split the sentence to the words
            m1 = strfind(newstr, BMI_words2(1,1));
            m2 = strfind(newstr, BMI_words2(1,2));
            m3 = strfind(newstr, BMI_words2(1,3));
            
            % replace arrays
            tfm1 = cellfun('isempty', m1);  % true for empty cells
            tfm2 = cellfun('isempty', m2); 
            tfm3 = cellfun('isempty', m3);  
            m1(tfm1) = {0}; 
            m2(tfm2) = {0}; 
            m3(tfm3) = {0}; 
            m1 = cell2mat(m1);
            m2 = cell2mat(m2);
            m3 = cell2mat(m3);
            a1 = find(m1==1);
            a2 = find(m2==1);
            a3 = find(m3==1);
            
            % calculate BMI
            feet = str2double(newstr(a1-1, 1));
            inches = str2double(newstr(a2-1, 1));
            pounds = str2double(newstr(a3-1, 1));
            
            height = feet*0.3048 + inches*0.0254;
            weight = pounds*0.453;
            
            BMI_cal(k,1) = weight/height^2;
            if(BMI_cal(k,1) > 30)
                Obesity(k,1) = 1;
            end
        end
    end
       
        % output
        Filename(k,1) = {files(i).name};  
           
end   

% Obesity status
Obesity2 = twowords_det(dirpath, obese_words2);
Obesity3 = twowords_det(dirpath, obese_words3);
Obesity4 = twowords_det(dirpath, obese_words4);
Obesity5 = twowords_det(dirpath, obese_words5);
Obesity6 = twowords_det(dirpath, obese_words5);
Obesity = Obesity | Obesity2 | Obesity3 | Obesity4 | Obesity5 | Obesity6;

% output
T = table(Filename, Obesity);  
%writetable(T,'result.csv');

% result
%TP = sum(Obesity(201:400, 1));
%FP = sum(Obesity(1:200, 1));