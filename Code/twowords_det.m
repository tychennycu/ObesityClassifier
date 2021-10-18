% words detector
% for two words

function Disease = twowords_det(dirpath, words)

% ex:
% words = {'eScription', 'VSSten'};

files=dir(dirpath);
nf=length(files);

Disease = zeros(nf-2, 1);
word1_count = 0;
word2_count = 0;

for i=3:nf
    
    k = i-2;
    
    % open file
    filename = strcat(dirpath, '/', files(i).name);
    
    % split into words
    str = extractFileText(filename); 
    sentences = splitSentences(str);  %split the text to the sentences
    
    for c = 1:length(sentences)
        symbolicseq = split(sentences(c, 1));  %split the sentences to the words
        
        for c2 = 1:length(symbolicseq)  
            
            for c3 =1:length(words) 

                % detect the words in every sentence
                match_1 = strcmpi(symbolicseq{c2}, words(1,1));  
                match_2 = strcmpi(symbolicseq{c2}, words(1,2));
                
                if sum(match_1) > 0          
                    word1_count =  1;
                end
                if sum(match_2) > 0          
                    word2_count =  1;
                end
                
            end
        
            if word1_count + word2_count == 2  % twowords are in the sentence
                Disease(k, 1) = 1;
            end
            
        end      

        % reset counts
        word1_count = 0; 
        word2_count = 0;
        
    end            
end   
end