classdef convertir_a_blanco_negro_con_bordesTest < matlab.unittest.TestCase
    methods (Test)
        function testCasoPerfecto(testCase)
            img = cat(1, 100 * ones(1, 4), cat(2, 100 * ones(2, 1), 200 * ones(2, 2), 100 * ones(2, 1)), 100 * ones(1, 4));
            expectedResult = cat(1, zeros(1, 4), cat(2, zeros(2, 1), ones(2, 2), zeros(2, 1)), zeros(1, 4));
            actualResult = convertir_a_blanco_negro_con_bordes(img);
            testCase.verifyEqual(actualResult, expectedResult);
        end

        function testCasoImperfecto(testCase)
            img = cat(1, 100*ones(1, 4), cat(2, 200*ones(2, 3), 100*ones(2, 1)), cat(2, 100*ones(1, 3), 200));
            expectedResult = cat(1, 0*ones(1, 4), cat(2, 1*ones(2, 3), 0*ones(2, 1)), cat(2, 0*ones(1, 3), 1));
            actualResult = convertir_a_blanco_negro_con_bordes(img);
            testCase.verifyEqual(actualResult, expectedResult);
        end
    end
end
