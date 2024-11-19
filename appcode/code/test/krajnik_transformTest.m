classdef krajnik_transformTest < matlab.unittest.TestCase
    methods (Test)
        function testBasico(testCase)
            RGB = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            theta = pi/4;
            logR = log(double(RGB(:,:,1)) + 1);
            logG = log(double(RGB(:,:,2)) + 1);
            logB = log(double(RGB(:,:,3)) + 1);
            x_r = logR - logG;
            x_g = logG - logB;
            expectedResult = x_r * cos(theta) + x_g * sin(theta);
            actualResult = krajnik_transform(RGB, theta);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testValoresEntremos(testCase)
            RGB = cat(3, [1, 1; 1, 1], [1, 1; 1, 1], [1, 1; 1, 1]);
            theta = 0;
            logR = log(double(RGB(:,:,1)) + 1);
            logG = log(double(RGB(:,:,2)) + 1);
            logB = log(double(RGB(:,:,3)) + 1);
            x_r = logR - logG;
            x_g = logG - logB;
            expectedResult = x_r * cos(theta) + x_g * sin(theta);
            actualResult = krajnik_transform(RGB, theta);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testImagenUniforme(testCase)
            RGB = cat(3, [5, 5; 5, 5], [5, 5; 5, 5], [5, 5; 5, 5]);
            theta = pi/2;
            logR = log(double(RGB(:,:,1)) + 1);
            logG = log(double(RGB(:,:,2)) + 1);
            logB = log(double(RGB(:,:,3)) + 1);
            x_r = logR - logG;
            x_g = logG - logB;
            expectedResult = x_r * cos(theta) + x_g * sin(theta);
            actualResult = krajnik_transform(RGB, theta);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end
    end
end
