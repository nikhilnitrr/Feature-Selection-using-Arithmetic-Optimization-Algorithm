
function AOA = jArithmeticOptimizationAlgorithm(feat,label,opts)

% Parameters
lb = 0;
ub = 1;
thres = 0.5;
MOP_Max = 1;
MOP_Min = 0.2;
alpha = 5;
Mu = 0.499;

if isfield(opts,'N'), N = opts.N; end
if isfield(opts,'T'), max_Iter = opts.T; end
if isfield(opts,'MOP_Max'), MOP_Max = opts.MOP_Max; end 
if isfield(opts,'MOP_Min'), MOP_Min = opts.MOP_Min; end 
if isfield(opts,'alpha'), alpha = opts.alpha; end 
if isfield(opts,'Mu'), Mu = opts.Mu; end
if isfield(opts,'thres'), thres = opts.thres; end

%objective function
fun = @jFitnessFunction;

%Number of dimensions
dim = size(feat,2);

% Initial
X   = zeros(N,dim);               % Here I'am having small doubt
for i = 1:N
  for d = 1:dim
    X(i,d) = lb + (ub - lb) * rand();
  end
end 


%Fitness
fit = zeros(1,N);
fitG = inf;


%Calculate the fitness values of solutions
for i=1:N
    fit(i)=fun(feat,label,(X(i,:)>thres),opts);  %having doubt here
    if fit(i)<fitG
        fitG=fit(i);
        Xgb=X(i,:);
    end
end
    
Xnew = zeros(N,dim);  
%Fnew = zeros(1,size(Xnew,1)); % havind doubt in this particular line %
curve = zeros(1,max_Iter);
t=1;

while t<max_Iter+1  %Main loop
    MOP=1-((t)^(1/alpha)/(max_Iter)^(1/alpha));   % Probability Ratio 
    MOA=MOP_Min+t*((MOP_Max-MOP_Min)/max_Iter); %Accelerated function
   
    %Update the Position of solutions
    for i=1:N  % if each of the UB and LB has a just value 
        for j=1:dim
           r1=rand();
            if (size(lb,2)==1)
                if r1<MOA
                    r2=rand();
                    if r2>0.5
                        Xnew(i,j)=Xgb(1,j)/(MOP+eps)*((ub-lb)*Mu+lb);
                    else
                        Xnew(i,j)=Xgb(1,j)*MOP*((ub-lb)*Mu+lb);
                    end
                else
                    r3=rand();
                    if r3>0.5
                        Xnew(i,j)=Xgb(1,j)-MOP*((ub-lb)*Mu+lb);
                    else
                        Xnew(i,j)=Xgb(1,j)+MOP*((ub-lb)*Mu+lb);
                    end
                end               
            end
            
           
            if (size(lb,2)~=1)   % if each of the UB and LB has more than one value 
                r1=rand();
                if r1<MOA
                    r2=rand();
                    if r2>0.5
                        Xnew(i,j)=Xgb(1,j)/(MOP+eps)*((ub(j)-lb(j))*Mu+lb(j));
                    else
                        Xnew(i,j)=Xgb(1,j)*MOP*((ub(j)-lb(j))*Mu+lb(j));
                    end
                else
                    r3=rand();
                    if r3>0.5
                        Xnew(i,j)=Xgb(1,j)-MOP*((ub(j)-lb(j))*Mu+lb(j));
                    else
                        Xnew(i,j)=Xgb(1,j)+MOP*((ub(j)-lb(j))*Mu+lb(j));
                    end
                end               
            end
            
        end
        
        Flag_UB=Xnew(i,:)>ub; % check if they exceed (up) the boundaries
        Flag_LB=Xnew(i,:)<lb; % check if they exceed (down) the boundaries
        Xnew(i,:)=(Xnew(i,:).*(~(Flag_UB+Flag_LB)))+ub.*Flag_UB+lb.*Flag_LB;
 
        Fnew =fun(feat,label,(Xnew(i,:)),opts);  % calculate Fitness function 
        if Fnew <fit(i)
            X(i,:)=Xnew(i,:);
            fit(i)=Fnew;
        end
        if fit(i)<fitG
        fitG=fit(i);
        Xgb=X(i,:);
        end
       
    end
    

    %Update the convergence curve
    curve(t)=fitG;
    fprintf('\nIteration %d Best (AOA)= %f',t,curve(t))
    t=t+1;  % incremental iteration
   
end

% select features based on selected index
Pos   = 1:dim;
Sf    = Pos((Xgb > thres) == 1);
sFeat = feat(:,Sf);


% Store results
AOA.sf = Sf; 
AOA.ff = sFeat; 
AOA.nf = length(Sf);
AOA.c  = curve; 
AOA.f  = feat; 
AOA.l  = label;
end



