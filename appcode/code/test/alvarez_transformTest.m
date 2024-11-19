classdef alvarez_transformTest < matlab.unittest.TestCase
    methods (Test)
        function testBasico(testCase)
            RGB = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            theta = pi/4;
            alpha = 1;
            expectedResult = cos(theta) * alpha * (((RGB(:,:,1) ./ RGB(:,:,3)) / alpha) - 1) + ...
                             sin(theta) * alpha * (((RGB(:,:,2) ./ RGB(:,:,3)) / alpha) - 1);
            actualResult = alvarez_transform(RGB, theta, alpha);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testValoresEntremos(testCase)
            RGB = cat(3, [1, 1; 1, 1], [1, 1; 1, 1], [1, 1; 1, 1]);
            theta = 0;
            alpha = 0.0001;
            expectedResult = cos(theta) * alpha * (((RGB(:,:,1) ./ RGB(:,:,3)) / alpha) - 1) + ...
                             sin(theta) * alpha * (((RGB(:,:,2) ./ RGB(:,:,3)) / alpha) - 1);
            actualResult = alvarez_transform(RGB, theta, alpha);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testImagenUniforme(testCase)
            RGB = cat(3, [5, 5; 5, 5], [5, 5; 5, 5], [5, 5; 5, 5]);
            theta = pi/2;
            alpha = 10;
            expectedResult = cos(theta) * alpha * (((RGB(:,:,1) ./ RGB(:,:,3)) / alpha) - 1) + ...
                             sin(theta) * alpha * (((RGB(:,:,2) ./ RGB(:,:,3)) / alpha) - 1);
            actualResult = alvarez_transform(RGB, theta, alpha);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testImagenBlancoNegro(testCase)
            RGB = cat(3, [1, 2; 3, 4], [1, 2; 3, 4], [1, 2; 3, 4]);
            theta = pi/3;
            alpha = 2;
            expectedResult = cos(theta) * alpha * (((RGB(:,:,1) ./ RGB(:,:,3)) / alpha) - 1) + ...
                             sin(theta) * alpha * (((RGB(:,:,2) ./ RGB(:,:,3)) / alpha) - 1);
            actualResult = alvarez_transform(RGB, theta, alpha);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end
    end
end
