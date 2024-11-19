classdef moda_colorTest < matlab.unittest.TestCase
    methods (Test)
        function testBasico(testCase)
            colores = [255, 0, 0; 255, 0, 0; 0, 255, 0; 0, 0, 255];
            expectedColor = [255, 0, 0];
            expectedFrecuencia = 2;
            [actualColor, actualFrecuencia] = moda_color(colores);
            testCase.verifyEqual(actualColor, expectedColor);
            testCase.verifyEqual(actualFrecuencia, expectedFrecuencia);
        end


        function testColoresUnicos(testCase)
            colores = [255, 0, 0; 0, 255, 0; 0, 0, 255; 255, 255, 0];
            expectedColor = [0, 0, 255];
            expectedFrecuencia = 1;
            [actualColor, actualFrecuencia] = moda_color(colores);
            testCase.verifyEqual(actualColor, expectedColor);
            testCase.verifyEqual(actualFrecuencia, expectedFrecuencia);
        end
    end
end
