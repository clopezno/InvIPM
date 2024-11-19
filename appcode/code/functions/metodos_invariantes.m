function imagen_resultado = metodos_invariantes(opcion, imagen_tres_canales)
    switch opcion
        case 1
            imagen_resultado = alvarez_transform(imagen_tres_canales, 45, .5);
        case 2
            imagen_resultado = maddern_transform(imagen_tres_canales, calcular_alpha(620, 540, 470));
        case 3
            imagen_resultado = krajnik_transform(imagen_tres_canales, calcular_theta_krajnik(imagen_tres_canales));
        case 4
            imagen_resultado = upcroft_transform(imagen_tres_canales, calcular_alpha(620, 540, 470));
        case 5
            imagen_resultado = PCA(imagen_tres_canales);
    end
    imagen_resultado(imagen_resultado > 1) = 1;
    min_val = min(imagen_resultado(:));
    max_val = max(imagen_resultado(:));
    imagen_normalizada = (imagen_resultado - min_val) / (max_val - min_val);
    imagen_resultado = uint8(255 * imagen_normalizada );
end
