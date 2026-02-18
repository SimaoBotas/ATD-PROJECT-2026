clc;
clear;

%% 10 carregar dados anteriores 

data  = load('processed_data.mat');

data = data.processed_data;



%% 11

numFiles = height(data);  
data.Fourier = cell(numFiles, 1);

Fs = data.taxaAmostragem(1);
n = length(data.signal{1}); 

for i = 1:numFiles
    signal = data.signal{i};  
    y = fft(signal);
    f = (0:n-1) * (Fs / n); 
    data.Fourier{i} = abs(y);
end
%% 12


Fs = data.taxaAmostragem(1); 
medianSpectra = cell(10, 1);
q1Spectra = cell(10, 1);
q3Spectra = cell(10, 1);
freqAxes = cell(10, 1); 

for d = 1:10
    digitIndices = find(data.digit == d-1);
    numSamples = length(digitIndices);
    allSpectra = [];
    
   % n = length(data.Fourier{digitIndices(1)});
    freq = (0:n-1) * (Fs / n);
    freq_pos = freq(1:floor(n/2)+1); 
    freqAxes{d} = freq_pos;

    for i = 1:numSamples
        idx = digitIndices(i);
        fullSpectrum = data.Fourier{idx};  
        n = length(fullSpectrum); 
        
        spectrum = fullSpectrum / n;  % Normaliza
        posSpectrum = spectrum(1:floor(n/2)+1);

        allSpectra = [allSpectra; posSpectrum'];
    end

    medianSpectra{d} = median(allSpectra, 1);
    q1Spectra{d} = quantile(allSpectra, 0.25, 1);
    q3Spectra{d} = quantile(allSpectra, 0.75, 1);
end


figure;
maxFreq = 8000;
ymax = 0.010;

for d = 1:10
    subplot(5, 2, d);
    hold on;
    
    freq = freqAxes{d};
    mask = freq <= maxFreq; 
    
    plot(freq(mask), medianSpectra{d}(mask), 'Color', 'r', 'LineWidth', 2);
    plot(freq(mask), q1Spectra{d}(mask), 'Color', 'b', 'LineWidth', 1.5);
    plot(freq(mask), q3Spectra{d}(mask), 'Color', 'y', 'LineWidth', 1.5);
    
    title([num2str(d-1)]);
    xlabel('Frequencia (Hz)');
    ylabel('Amplitude');
    grid on;
    xlim([0, maxFreq]); 
    ylim([0,ymax]);
    
    if d == 1
        legend('Mediana', 'Q1 (25%)', 'Q3 (75%)', 'Location', 'northeast');
    end
end

sgtitle('Estaticas Espetro (0–8000 Hz)');



%% 13 e 14

data = getSpectralFeatures(data,numFiles);


%% 15

save ('meta2_data.mat','data');