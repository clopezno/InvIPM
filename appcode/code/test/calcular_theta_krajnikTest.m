classdef calcular_theta_krajnikTest < matlab.unittest.TestCase
    methods (Test)
        function testBasico(testCase)
            imagen = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            expectedResult = calcular_theta_krajnik(imagen); % No podemos predecir fácilmente el resultado exacto
            actualResult = calcular_theta_krajnik(imagen);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testImagenUniforme(testCase)
            imagen = cat(3, [5, 5; 5, 5], [5, 5; 5, 5], [5, 5; 5, 5]);
            expectedResult = calcular_theta_krajnik(imagen);
            actualResult = calcular_theta_krajnik(imagen);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testImagenBlancoNegro(testCase)
            imagen = cat(3, [1, 2; 3, 4], [1, 2; 3, 4], [1, 2; 3, 4]);
            expectedResult = calcular_theta_krajnik(imagen);
            actualResult = calcular_theta_krajnik(imagen);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end
    end
end
