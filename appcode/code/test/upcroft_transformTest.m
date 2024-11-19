classdef upcroft_transformTest < matlab.unittest.TestCase
    methods (Test)
        function testBasico(testCase)
            RGB = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            alpha = 0.5;
            expectedResult = log(RGB(:,:,2)) - alpha * log(RGB(:,:,3)) - (1 - alpha) * log(RGB(:,:,1));
            actualResult = upcroft_transform(RGB, alpha);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testValoresEntremos(testCase)
            RGB = cat(3, [1, 1; 1, 1], [1, 1; 1, 1], [1, 1; 1, 1]);
            alpha = 0;
            expectedResult = log(RGB(:,:,2)) - alpha * log(RGB(:,:,3)) - (1 - alpha) * log(RGB(:,:,1));
            actualResult = upcroft_transform(RGB, alpha);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end

        function testImagenUniforme(testCase)
            RGB = cat(3, [5, 5; 5, 5], [5, 5; 5, 5], [5, 5; 5, 5]);
            alpha = 1;
            expectedResult = log(RGB(:,:,2)) - alpha * log(RGB(:,:,3)) - (1 - alpha) * log(RGB(:,:,1));
            actualResult = upcroft_transform(RGB, alpha);
            testCase.verifyEqual(actualResult, expectedResult, 'AbsTol', 1e-10);
        end
    end
end
