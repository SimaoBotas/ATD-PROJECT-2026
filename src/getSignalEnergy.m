function energy = getSignalEnergy(sinal, t_inicial, t_final)
    segmento = sinal(t_inicial:t_final);
    energy = sum(segmento .^ 2);
end
