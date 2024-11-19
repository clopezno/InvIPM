function [imagen_final, porcentaje] = metodos_agrupamiento(opcion, imagen, img_ground_truth, numClusters)
    maxIter = 10;
    switch opcion
        case 1
            % Elijo aplicar el método de K-Means a la imagen.
            [imagen_final, ~] = segmentar_imagen_KMeans(imagen, numClusters, maxIter);
        case 2
            % Decido usar Fuzzy C-Means para segmentar la imagen.
            [imagen_final, ~] = segmentar_imagen_fuzzy_CMeans(imagen, numClusters, maxIter);
        case 3
            % Opto por aplicar el método GMM para la segmentación.
            [imagen_final, ~] = segmentar_imagen_GMM(imagen, numClusters, maxIter);
        case 4
            % Uso HMRF-EM-image de Quan Wang
            Y = rgb2gray(imagen);
            Z = edge(Y, 'canny', 0.75);
            Y = double(Y);
            Y = gaussianBlur(Y, 3);
            EM_iter = 3; % max num of iterations
            MAP_iter = 3; % max num of iterations
            [X, mu, sigma] = image_kmeans(Y, numClusters);
            [X, mu, sigma] = HMRF_EM(X, Y, Z, mu, sigma, numClusters, EM_iter, MAP_iter);
            imagen_final = (uint8(X*120));
        otherwise
            % Si la opción no es reconocida, aviso al usuario.
            disp('Opción no válida');
            imagen_final = imagen; % Devuelvo la imagen original.
    end
    % Determino cómo de acertada fue la segmentación comparando con el ground truth.
    if isempty(img_ground_truth)
        porcentaje = NaN; % No hay ground truth, porcentaje no aplicable
    else
        porcentaje = calcular_coincidencia(imagen_final, img_ground_truth);
    end
end
