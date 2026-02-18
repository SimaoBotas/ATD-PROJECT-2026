clc;
clear;
close all;

data_cleaned = false; % usada no menu de escolha de visualização de dados
signal_length = 0.5; % usado no ponto 4 no processamento de dados
divisions = 3; %usado no ponto 7 para calculo de diferenças entre digitos;
menu = true; %colocar a false para saltar a etapa inicial de estudo dos sinais

%% 1
% Feito na secção 2 , na função getDataFromFiles;

%% 2

[data,numFiles] = getDataFromFiles;


%dados já limpos, ou seja
%Silencio inicial Removido
%Normalizados para entre -1 e 1
%Zeros Adicionados ou ruidos finais removidos para que os audios fiquem com
%um só valor, dado por signal_length

%% ponto 4 da ficha, realizado antes para evitar esperas dentro do loop
processed_data = processData(data,numFiles,signal_length); %tabela onde está guardada os sinais apos processamento


%% 3 ou 5 , escolhido pelo utilizador

%pequeno menu para optar escolher entre visualizar o sinal "raw" ou limpo,
%tal como escolher visualizar 10 repeticoes de um digito, ou o mesmo numero
%de repeticao para todos os digitos, ferramenta para estudo inicial dos
%sinais

if(menu)
while true

user_choice = input("Pretende visualizar a repetição ou o digito ('r' or 'd') ('l' para limpar sinais)('c' para continuar)\n",'s');

if user_choice == 'l'
  data_cleaned = ~data_cleaned;
  continue;
end

if user_choice == 'c' ||user_choice == 'C'
break;
end

if user_choice == 'r' || user_choice == 'R'

repeticao = -1;

while(repeticao <0 || repeticao > 49)
repeticao = input("Numero da repetição (0-49) :\n");
digit = -1;
end

repeticaotext = "Repeticao " + string(repeticao);
elseif user_choice == 'd' || user_choice == 'D'

digit = input("Digito 0-9 :\n");
repeticao = -1;

digittext = "Digito " + string(digit);

end

%modo digito
if repeticao == -1

if(data_cleaned == true)
digito_data = processed_data(processed_data.digit == digit,:);

else
digito_data = data(data.digit == digit,:);
end

j = randperm(49,10);
j = sort(j);

for  i = 1:10
if(i == 1)

 screenSize = get(0,'ScreenSize');

 width = 1000;
 height = 600;    
 left = (screenSize(3) - width) / 2;
 bottom = (screenSize(4) - height) / 2;
 figure('Position', [left, bottom, width, height]);
end

subplot(5,2,i);

rep_aux = j(i);

title("Repetição "+ digito_data.repnumber(rep_aux));

hold on;

audio = digito_data.signal{rep_aux};
ts = digito_data.taxaAmostragem(rep_aux);

t = (0:length(audio)-1) / ts;

plot(t,audio);

grid on;
sgtitle(digittext)
end
end

% modo repeticao
if(digit == -1)

if(data_cleaned == true)
repeticao_data = processed_data(processed_data.repnumber == repeticao,:);

else
repeticao_data = data(data.repnumber == repeticao,:);
end

for i = 1:10

if(i == 1)

 screenSize = get(0,'ScreenSize');

 width = 1000;
 height = 600;    
 left = (screenSize(3) - width) / 2;
 bottom = (screenSize(4) - height) / 2;
    
figure('Position', [left, bottom, width, height]);

end
subplot(5,2,i);

audio = repeticao_data.signal{i};
ts = repeticao_data.taxaAmostragem(i);
t = (0:length(audio)-1) /ts;


plot(t,audio);
grid on;
title("Digito:"+repeticao_data.digit(i))
sgtitle(repeticaotext)

end
end
end
end

%% 6,7,8

processed_data = compareDigitsFeatures(processed_data,divisions);


%% 9

%processed_data.signal = removevars(processed_data,'signal');

save('processed_data.mat','processed_data');

