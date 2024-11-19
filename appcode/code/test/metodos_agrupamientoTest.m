classdef metodos_agrupamientoTest < matlab.unittest.TestCase
    methods (Test)
        function testKMeansSinGT(testCase)
            imagen = rand(100, 100, 3);
            img_ground_truth = [];
            opcion = 1;
            numClusters = 3;
            [imagen_final, porcentaje] = metodos_agrupamiento(opcion, imagen, img_ground_truth, numClusters);
            testCase.verifyNotEmpty(imagen_final);
            testCase.verifyEqual(porcentaje, NaN)
        end
        
        function testKMeansGT(testCase)
            imagen = rand(100, 100, 3);
            img_ground_truth = ones(100, 100);
            opcion = 1;
            numClusters = 3;
            [imagen_final, porcentaje] = metodos_agrupamiento(opcion, imagen, img_ground_truth, numClusters);
            testCase.verifyNotEmpty(imagen_final);
            testCase.verifyGreaterThanOrEqual(porcentaje, 0);
        end
    end
end
