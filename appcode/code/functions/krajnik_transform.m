function I_Krajnik = krajnik_transform(RGB, theta)
    % Separación de la imagen RGB por canales en double
    R = double(RGB(:,:,1));
    G = double(RGB(:,:,2));
    B = double(RGB(:,:,3));
    
    % Cálculo la cromaticidad logarítmica mas 1 para evitar log(0)
    logR = log(R + 1);
    logG = log(G + 1);
    logB = log(B + 1);
    
    % Cálculo de x_r y x_g
    x_r = logR - logG;
    x_g = logG - logB;
    
    % Transformación invariante
    I_Krajnik = x_r * cos(theta) + x_g * sin(theta);
end
