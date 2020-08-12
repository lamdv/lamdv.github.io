# MODEL SELECTION

***or Machine learning Machine Learning***
<!-- part 2 -->

## Criterions: Loss function for functions

Now, how can we select the correct hyperparameter? While normal parameters are tuned by loss function, there is no such concept for hyperparameter - a hyperloss function perhap? As it turn out, there are several criteria that can be used to judge the performance of our model.

As mention, pure loss is not a valid criteria to judge the performance of a model. More statistical approachs is required, ranging from extension of validation to penalized criteria aim to further regulate the model. In this post we will focus on BIC/AIC and AUC.

### AUC: which curve you're talking about?

Area under curve is one of the major model benchmarking criteria. If we plot the True Positive Rate (TPR) versus the False Postive Rate (FPR), we obtain a plot called *Receiver Operating Charateristic*, or ROC curve.

### Information Criterion

## Some viable algorithms for selecting $\lambda$

### Heuristic methods

### Deterministic methods

## Conclusion

In practice, a larger model is not guarantee a better prediction power (and in most case, worst). Overfitting, loss of generalization and loss of interpretability are some among major problems
