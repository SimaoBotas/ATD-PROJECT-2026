function audio_trimmed = removeInitialSilence(audio, ts,threshold)
  %funcao para remover o silencio inicial dos sinais

    h = 0.005; 
    step_length = h * ts;
    n = floor(length(audio) / step_length);
    energy = zeros(n, 1);


    %divide em "frames" e calcula a energia de cada frame
    for j = 1:n
        step = audio((j - 1) * step_length + 1 : min(j * step_length, length(audio)));
        energy(j) = trapz(step .^ 2);
    end

    energy = energy / max(energy);

    start_index = find(energy > threshold, 1) * step_length;

    audio_trimmed = audio(start_index:end);
end
