# 

***or Machine learning Machine Learning***

<!-- part 1 -->

Author note: I'm writing this document while waiting for my surgery to keep my mind occupied. For now I'm in too much pain to ramble on; I will follow up with the methods as soon as I can. Please excuse poor ass English usage.

## Part 1: Problem of Model Selection

### So, what is a Model?

A model is "simply" a function $f(x,\alpha) \in R^{d_y}$. Intuitively, the model describes a (statistical) connection between phenominons, or in a more "Data science-ish" term, describes the connection between the inputs and output.

As most people with interest in DS well aware, the core tenet of Machine Learning is to find the $\alpha$ such that

$$
argmin_\alpha \hat L(f_\alpha(x),y)
$$

where $\hat L$ is a loss function. In fact, this problem can be solve relatively easy for a certain function $f(x,\alpha)$. Howerver reality is usually more complex and the reality of our model is similar. Generally we would not work with just a function, but a family of functions $f \in F$.

Enter **Hyperparameter**.

### Excusez-moi?

**Hyperparameters** are parameters that instead of describe the connection between the observations and the output, they describe the difference between models of the same family. For example we are all well aware of hyperparameters of a neural network: its depth (number of layers) and its width (number of units in each layer). 2 models of a same family will give different prediction performance as well as require different computing performance.

Theoretically we want as much information as possible in our model: input everything, compute every possible connection and let the model learn itself out. However our model is a mere approximation of the real connection - there are noise, there are missing parameters, hidden parameters and useless parameters. Trying to incorporate everything into our model will inevitably lead to the words that make all computer scientist squimish: OVERFIT. Fucking overfit.

Therefore we need to regulate the parameters that will be included in our computation. Considering linear regression, we come to LASSO.

### LASSO

Lasso is a model selection and regularization algorithm for linear regression. Why do we care? Well, for linear regression, the number of hyperparameters is actually astronomical: for each parameters there is a binary hyperparameters describe if it is in or out of the model (or of course we set the weight to 0, but then how can we tell which parameter to left out?). LASSO solve this problem elegantly by introducing the concept of *l1-regularization*. 

Intuitively, with the assumption that not all parameters are useful, we penalize the models with too many parameters. Concretely, Lasso regularization is
$$
argmin_\alpha \quad ||y - f_\alpha(x)||_2 + \lambda||\alpha||_1
$$

Evidently, the more $\alpha$s the higher loss function will be. Intuitively the balance between loss from function and loss from regularization is controlled by $\lambda$. The higher $\lambda$, the fewer parameters actually enter the model. By controlling $\lambda$ we aviod the problem of have to identify which individual parameters with enter the model.

#### To be continued
