  function [data,numFiles] = getDataFromFiles()
%Funcao para buscar os dados dos ficheiros, devolvendo o numero de
%ficheiros e os ficheiros em si, dentro de uma tabela

file_path = 'data'; % pasta onde estão os ficheiros

audiofiles = dir(fullfile(file_path,'*.wav')); %apenas usar os ficheiros .wav

numFiles = length(audiofiles);

%criação da tabela, com prealocação para o numero de ficheiros
data = table(strings(numFiles,1),strings(numFiles,1),strings(numFiles,1),zeros(numFiles,1),zeros(numFiles,1),zeros(numFiles,1),cell(numFiles,1), ...
    'VariableNames', {'directory','participant','fileName','digit','repnumber','taxaAmostragem','signal'});

data.directory(:) = file_path;

for i=1:numFiles

    name = string(audiofiles(i).name);

    parts = erase(name,".wav");

    parts = split(parts,"_");

    digit = str2double(parts(1));
    participant = str2double(parts(2));
    repnumber = str2double(parts(3));


    fullPath = fullfile(file_path,name);

    [audio,ts] = audioread(fullPath);

    data.fileName(i) = name;
    data.digit(i) = digit;
    data.repnumber(i) = repnumber;
    data.participant(i) = participant; %pode ser feito em cima com o path para o folder
    data.signal{i} = audio;
    data.taxaAmostragem(i) = ts;
    
end

data = sortrows(data,["digit","repnumber"]);





   
 