classdef calcular_coincidenciaTest < matlab.unittest.TestCase
    methods (Test)
        function testImagenesIguales(testCase)
            img1 = cat(1, zeros(1, 4), cat(2, zeros(2, 1), ones(2, 2), zeros(2, 1)), zeros(1, 4));
            img2 = cat(1, zeros(1, 4), cat(2, zeros(2, 1), ones(2, 2), zeros(2, 1)), zeros(1, 4));
            expectedResult = 100;
            actualResult = calcular_coincidencia(img1, img2);
            testCase.verifyEqual(actualResult, expectedResult);
        end

        function testImagenesDiferentes(testCase)
            img1 = cat(1, zeros(1, 4), cat(2, zeros(2, 1), ones(2, 2), zeros(2, 1)), zeros(1, 4));
            img2 = cat(1, 0*ones(1, 4), cat(2, 1*ones(2, 3), 0*ones(2, 1)), cat(2, 0*ones(1, 3), 1));
            expectedResult = 81.25;
            actualResult = calcular_coincidencia(img1, img2);
            testCase.verifyEqual(actualResult, expectedResult);
        end
    end
end
