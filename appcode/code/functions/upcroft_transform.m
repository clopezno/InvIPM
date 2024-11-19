function I_Upcroft = upcroft_transform(RGB, alpha)
    % Separación de la imagen RGB por canales en double
    R = double(RGB(:,:,1));
    G = double(RGB(:,:,2));
    B = double(RGB(:,:,3));
    
    % Transformación invariante
    I_Upcroft = log(G) - alpha*log(B) - (1 - alpha)*log(R);
end
