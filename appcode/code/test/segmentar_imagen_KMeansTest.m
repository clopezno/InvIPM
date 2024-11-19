classdef segmentar_imagen_KMeansTest < matlab.unittest.TestCase
    methods (Test)
        function testBasicoKMeans(testCase)
            imagen = rand(100, 100, 3);
            numClusters = 3;
            maxIter = 100;
            [imgResultante, centers] = segmentar_imagen_KMeans(imagen, numClusters, maxIter);
            testCase.verifyEqual(size(imgResultante), [100, 100, 3]);
            testCase.verifyEqual(size(centers, 1), numClusters);
        end
    end
end
