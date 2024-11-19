function [color, frecuencia] = moda_color(colores)
    % Calculo la moda (el color más frecuente) de una lista de colores.
    % Para ello, primero convierto la matriz de colores a una forma que pueda procesar.
    [unicos, ~, idx] = unique(reshape(colores, [], size(colores, 2)), 'rows');
    
    % Encuentro el índice de la moda de los colores únicos.
    moda_idx = mode(idx);
    
    % Obtengo el color que corresponde a la moda.
    color = unicos(moda_idx, :);
    
    % Calculo la frecuencia del color de la moda en la lista original.
    frecuencia = sum(idx == moda_idx);
end
