function I_Alvarez = alvarez_transform(RGB, theta, alpha)
    % Separación de la imagen RGB por canales en double
    R = double(RGB(:,:,1));
    G = double(RGB(:,:,2));
    B = double(RGB(:,:,3));
    
    % Calcular las relaciones entre los canales rojo-azul y verde-azul
    RB_ratio = R ./ B;
    GB_ratio = G ./ B;
    
    % Aproximación logarítmica RB y GB
    log_approx_RB = alpha * ((RB_ratio / alpha) - 1);
    log_approx_GB = alpha * ((GB_ratio / alpha) - 1);
    
    % Transformación invariante
    I_Alvarez = cos(theta) * log_approx_RB + sin(theta) * log_approx_GB;
end
