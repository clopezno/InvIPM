classdef segmentar_imagen_fuzzy_CMeansTest < matlab.unittest.TestCase
    methods (Test)
        function testBasicoFuzzyCMeans(testCase)
            imagen = rand(100, 100, 3);
            numClusters = 3;
            maxIter = 100;
            [imgResultante, centers] = segmentar_imagen_fuzzy_CMeans(imagen, numClusters, maxIter);
            testCase.verifyEqual(size(imgResultante), [100, 100, 3]);
            testCase.verifyEqual(size(centers, 1), numClusters);
        end
    end
end
