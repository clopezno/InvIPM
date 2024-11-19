classdef check_cacheTest < matlab.unittest.TestCase
    methods (Test)
        function testCacheExiste(testCase)
            tipo = 1;
            nombre = 'testImage';
            inv = 'inv';
            ext = '.png';
            cachePath = './cache';
            mkdir(cachePath);
            imwrite(rand(10), fullfile(cachePath, ['1__' nombre '__' inv ext]));
            [existe, imagen, porcentaje] = check_cache(tipo, nombre, inv, '', '', ext, cachePath);
            testCase.verifyTrue(existe);
            testCase.verifyNotEmpty(imagen);
            testCase.verifyEqual(porcentaje, 0);
            rmdir(cachePath, 's');
            % Borrar el directorio cache después de la verificación
            rmdir(cachePath, 's');
        end
    end
end
