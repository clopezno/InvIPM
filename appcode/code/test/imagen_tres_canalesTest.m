classdef imagen_tres_canalesTest < matlab.unittest.TestCase
    methods (Test)
        function testImagenCuatroCanales(testCase)
            % Caso de uso: Procesamiento de Imágenes con Alpha
            imagenOriginal = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12], [13, 14; 15, 16]);
            expectedResult = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            actualResult = imagen_tres_canales(imagenOriginal);
            testCase.verifyEqual(actualResult, expectedResult);
        end

        function testImagenTresCanales(testCase)
            % Caso de uso: Procesamiento de Imágenes sin Alpha
            imagenOriginal = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            expectedResult = imagenOriginal;
            actualResult = imagen_tres_canales(imagenOriginal);
            testCase.verifyEqual(actualResult, expectedResult);
        end
    end
end
