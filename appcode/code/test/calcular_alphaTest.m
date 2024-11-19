classdef calcular_alphaTest < matlab.unittest.TestCase
    methods (Test)
        function testValoresBasicos(testCase)
            lambda1 = 1;
            lambda2 = 2;
            lambda3 = 3;
            expectedResult = (lambda3 / (lambda3 - lambda1)) * (1/lambda2 - 1/lambda3);
            actualResult = calcular_alpha(lambda1, lambda2, lambda3);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testLambda1A0(testCase)
            lambda1 = 0;
            lambda2 = 2;
            lambda3 = 3;
            expectedResult = (lambda3 / (lambda3 - lambda1)) * (1/lambda2 - 1/lambda3);
            actualResult = calcular_alpha(lambda1, lambda2, lambda3);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testLambdasIguales(testCase)
            lambda1 = 2;
            lambda2 = 2;
            lambda3 = 2;
            expectedResult = (lambda3 / (lambda3 - lambda1)) * (1/lambda2 - 1/lambda3);
            actualResult = calcular_alpha(lambda1, lambda2, lambda3);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end
    end
end
