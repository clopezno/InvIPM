classdef segmentar_imagen_GMMTest < matlab.unittest.TestCase
    methods (Test)
        function testBasicoGMM(testCase)
            imagen = rand(100, 100, 3);
            numClusters = 3;
            maxIter = 100;
            [imgResultante, centers] = segmentar_imagen_GMM(imagen, numClusters, maxIter);
            testCase.verifyEqual(size(imgResultante), [100, 100, 3]);
            testCase.verifyEqual(size(centers, 1), numClusters);
        end
    end
end
