function [existe, imagen, porcentaje] = check_cache(tipo, nombre, inv, agrup, cen, ext, cachePath)
    % Inicializar las variables de salida
    existe = false;
    imagen = [];
    porcentaje = 0;
    
    % Definir el nombre esperado
    if tipo == 1
        objetivo = ['1__' nombre '__' inv ext];
    elseif tipo == 2
        objetivo = ['2__' nombre '__Original_' agrup '_' num2str(cen) '_c'];
    elseif tipo == 3
        objetivo = ['3__' nombre '__' inv '_' agrup '_' num2str(cen) '_c'];
    end

    % Buscar archivos en la caché
    files = dir(fullfile(cachePath, '*.*'));
    
    for file = files'
        if contains(file.name, objetivo)
            if tipo == 1
                % Si es tipo 1, no hay porcentaje
                existe = true;
                imagen = imread(fullfile(cachePath, file.name));
                return;
            else
                if contains(file.name, '%')
                    % Extraer el porcentaje del nombre del archivo
                    idx_c = strfind(file.name, '_c_') + 3;
                    idx_perc = strfind(file.name, '%');
                    porcentaje_str = file.name(idx_c:(idx_perc-1));
                    porcentaje = str2double(porcentaje_str);
                end

                existe = true;
                imagen = imread(fullfile(cachePath, file.name));
                return;
            end
        end
    end
end
