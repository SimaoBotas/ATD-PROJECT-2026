function output = getSpectralFeatures(data,numFiles)

% 1. Calcula as 3 características espectrais 

output = data;

% Pré-alocar espaço
output.PicoFreq = zeros(height(output), 1);
output.SpectralEdge = zeros(height(output), 1);
output.MediaAmp = zeros(height(output), 1);

percent = 0.95; % SEF_95

for i = 1:numFiles
    spectrum = output.Fourier{i}(1:floor(end/2)+1);
    n = length(spectrum);
    Fs = output.taxaAmostragem(i);
    freq = (0:n-1) * (Fs / (2*n));
    
    % Frequência do pico
    [~, max_idx] = max(spectrum);
    output.PicoFreq(i) = freq(max_idx);

    % Spectral Edge
    powerSpectrum = spectrum.^2;
    cumulativePower = cumsum(powerSpectrum);
    totalPower = cumulativePower(end);
    threshold = percent * totalPower;
    idxEdge = find(cumulativePower >= threshold, 1);
    output.SpectralEdge(i) = freq(idxEdge);
    
    % Amplitude média
    output.MediaAmp(i) = mean(spectrum);
end

digits = unique(output.digit);
colors = lines(length(digits));

figure;

% Frequência do Pico
subplot(3,1,1);
hold on;
for d = 1:length(digits)
    idx = find(output.digit == digits(d));
    scatter(repmat(digits(d), length(idx), 1), output.PicoFreq(idx), 36, colors(d,:), 'filled');
end
title('Frequência do Pico por Amostra');
xlabel('Dígito');
ylabel('Frequência (Hz)');
grid on;
xticks(digits);

% Spectral Edge
subplot(3,1,2);
hold on;
for d = 1:length(digits)
    idx = find(output.digit == digits(d));
    scatter(repmat(digits(d), length(idx), 1), output.SpectralEdge(idx), 36, colors(d,:), 'filled');
end
title('Spectral Edge (95%) por Amostra');
xlabel('Dígito');
ylabel('Frequência (Hz)');
grid on;
xticks(digits);

% Amplitude Média
subplot(3,1,3);
hold on;
for d = 1:length(digits)
    idx = find(output.digit == digits(d));
    scatter(repmat(digits(d), length(idx), 1), output.MediaAmp(idx), 36, colors(d,:), 'filled');
end
title('Amplitude Média por Amostra');
xlabel('Dígito');
ylabel('Amplitude');
grid on;
xticks(digits);

sgtitle('Distribuição das Características por Dígito (Todas as Amostras)');

end
