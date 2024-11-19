function theta = calcular_theta_krajnik(imagen)
    % Separar los canales RGB y calcular la cromaticidad logarítmica
    logR = log(double(imagen(:,:,1)) + 1);
    logG = log(double(imagen(:,:,2)) + 1);
    logB = log(double(imagen(:,:,3)) + 1);

    % Componentes cromáticas
    x_r = logR - logG;
    x_g = logG - logB;

    % Definir el rango de ángulos y valor inicial de entropía mínima
    angles = linspace(0, pi, 180);
    min_entropy = Inf;
    theta = 0;

    % Encontrar el ángulo que minimiza la entropía
    for angle = angles
        I_proj = x_r * cos(angle) + x_g * sin(angle);
        counts = histcounts(I_proj(:), 256, 'Normalization', 'probability');
        entropy_val = -sum(counts .* log(counts + eps));

        if entropy_val < min_entropy
            min_entropy = entropy_val;
            theta = angle;
        end
    end
end
