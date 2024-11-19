classdef metodos_invariantesTest < matlab.unittest.TestCase
    methods (Test)
        function testAlvarezTransform(testCase)
            imagen = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            opcion = 1;
            imagen_resultado = alvarez_transform(imagen, 45, .5);
            imagen_resultado(imagen_resultado > 1) = 1;
            expectedResult = uint8(255 * mat2gray(imagen_resultado));
            actualResult = metodos_invariantes(opcion, imagen);
            testCase.verifyEqual(actualResult, expectedResult);
        end

        function testMaddernTransform(testCase)
            imagen = cat(3, [1, 2; 3, 4], [5, 6; 7, 8], [9, 10; 11, 12]);
            opcion = 2;
            imagen_resultado = maddern_transform(imagen, calcular_alpha(620, 540, 470));
            imagen_resultado(imagen_resultado > 1) = 1;
            expectedResult = uint8(255 * mat2gray(imagen_resultado));
            actualResult = metodos_invariantes(opcion, imagen);
            testCase.verifyEqual(actualResult, expectedResult);
        end
    end
end
