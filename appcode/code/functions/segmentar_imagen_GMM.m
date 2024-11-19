function [imgResultante, centers] = segmentar_imagen_GMM(img, numClusters, maxIter)
    [height, width, ~] = size(img);
    datosImg = double(reshape(img, [], 3));

    % Aplico el Modelo de Mezclas Gaussianas con regularización
    % y especificando el tipo de covarianza
    options = statset('MaxIter', maxIter);
    gmm = fitgmdist(datosImg, numClusters, 'RegularizationValue', 1e-5, 'CovarianceType', 'diagonal', 'Options', options);

    % Asigno a cada píxel al cluster más probable
    membership = cluster(gmm, datosImg);
    
    % Obtengo los centros (medias) de cada componente gaussiana
    centers = gmm.mu;

    % Defino una paleta de colores RGB
    colores = [255, 0, 0; 0, 255, 0; 0, 0, 255; 255, 255, 0; 0, 255, 255; 255, 0, 255; 255, 127, 0; 127, 0, 255; 0, 127, 255; 127, 255, 0];
    colores = colores(1:numClusters, :); % Asegurarse de tener suficientes colores

    % Creo imagen resultante
    imgResultante = zeros(height * width, 3); % Para formato RGB
    for k = 1:numClusters
        idx = find(membership == k);
        imgResultante(idx, :) = repmat(colores(k, :), length(idx), 1);
    end

    % Cambio la forma de la imagen resultante al formato original
    imgResultante = uint8(reshape(imgResultante, [height, width, 3]));
end
