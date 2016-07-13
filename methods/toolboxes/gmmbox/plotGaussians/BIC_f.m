function [ bic ] = BIC_f(loglik,k,nbParamK,N)
%BIC

bic = -2*loglik + k*nbParamK*log(N);

end

