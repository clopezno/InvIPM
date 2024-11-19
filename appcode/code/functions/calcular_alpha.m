function alpha = calcular_alpha(lambda1, lambda2, lambda3)
    alpha = (lambda3 / (lambda3 - lambda1)) * (1/lambda2 - 1/lambda3);
end