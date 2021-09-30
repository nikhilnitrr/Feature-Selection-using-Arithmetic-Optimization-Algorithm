# Feature selection using Arithmetic optimization Algorithm

## Input

feat : feature vector matrix ( Instance x Features )

label : label matrix ( Instance x 1 )

opts : parameter settings

N : number of solutions / population size ( for all methods )

T : maximum number of iterations ( for all methods )

k : k-value in k-nearest neighbor

## Output

Acc : accuracy of validation model

FS : feature selection model ( It contains several results )

sf : index of selected features

ff : selected features

nf : number of selected features

c : convergence curve

t : computational time (s)
