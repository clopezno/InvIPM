% Lista de tests
testFiles = {
    'alvarez_transformTest'
    'calcular_alphaTest'
    'calcular_theta_krajnikTest'
    'calcular_coincidenciaTest'
    'check_cacheTest'
    'convertir_a_blanco_negro_con_bordesTest'
    'imagen_tres_canalesTest'
    'moda_colorTest'
    'metodos_invariantesTest'
    'metodos_agrupamientoTest'
    'segmentar_imagen_KMeansTest'
    'segmentar_imagen_fuzzy_CMeansTest'
    'segmentar_imagen_GMMTest'
};

% Inicializar los resultados
testNames = {};
numPassed = [];
numFailed = [];

% Ejecutar todos los tests y recopilar los resultados
for i = 1:numel(testFiles)
    disp(['Running ', testFiles{i}]);
    results = runtests(testFiles{i});
    
    % Recopilar resultados
    testNames{end+1} = testFiles{i};
    numPassed(end+1) = sum([results.Passed]);
    numFailed(end+1) = sum([results.Failed]);
end

% Crear tabla de resultados
resultsTable = table(testNames', numPassed', numFailed', 'VariableNames', {'TestName', 'Passed', 'Failed'});

% Mostrar la tabla
disp(resultsTable);
