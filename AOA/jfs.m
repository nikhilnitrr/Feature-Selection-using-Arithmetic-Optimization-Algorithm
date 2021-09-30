function model = jfs(type,feat,label,opts)
switch type
  case 'aoa'  ; fun = @jArithmeticOptimizationAlgorithm; 
end
tic;
model = fun(feat,label,opts); 
% Computational time
t = toc;

model.t = t;
fprintf('\n Processing Time (s): %f % \n',t); fprintf('\n');
end