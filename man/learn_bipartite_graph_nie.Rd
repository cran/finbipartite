% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/learn-bipartite-graph-nie.R
\name{learn_bipartite_graph_nie}
\alias{learn_bipartite_graph_nie}
\title{Laplacian matrix of a k-component bipartite graph via Nie's method

Computes the Laplacian matrix of a bipartite graph on the basis of an observed similarity matrix.}
\usage{
learn_bipartite_graph_nie(
  S,
  r,
  q,
  k,
  learning_rate = 1e-04,
  eta = 1,
  maxiter = 1000,
  reltol = 1e-06,
  verbose = TRUE,
  record_objective = FALSE
)
}
\arguments{
\item{S}{a p x p similarity matrix, where p is the number of nodes in the graph.}

\item{r}{number of nodes in the objects set.}

\item{q}{number of nodes in the classes set.}

\item{k}{number of components of the graph.}

\item{learning_rate}{gradient descent parameter.}

\item{eta}{rank constraint hyperparameter.}

\item{maxiter}{maximum number of iterations.}

\item{reltol}{relative tolerance as a convergence criteria.}

\item{verbose}{whether or not to show a progress bar during the iterations.}

\item{record_objective}{whether or not to record the objective function value during iterations.}
}
\value{
A list containing possibly the following elements:
\item{\code{laplacian}}{estimated Laplacian matrix}
\item{\code{adjacency}}{estimated adjacency matrix}
\item{\code{B}}{estimated graph weights matrix}
\item{\code{maxiter}}{number of iterations taken to reach convergence}
\item{\code{convergence}}{boolean flag to indicate whether or not the optimization converged}
\item{\code{obj_fun}}{objective function value per iteration}
}
\description{
Laplacian matrix of a k-component bipartite graph via Nie's method

Computes the Laplacian matrix of a bipartite graph on the basis of an observed similarity matrix.
}
\examples{
library(finbipartite)
library(igraph)
set.seed(42)
r <- 50
q <- 5
p <- r + q

bipartite <- sample_bipartite(r, q, type="Gnp", p = 1, directed=FALSE)
# randomly assign edge weights to connected nodes
E(bipartite)$weight <- 1
Lw <- as.matrix(laplacian_matrix(bipartite))
B <- -Lw[1:r, (r+1):p]
B[,] <- runif(length(B))
B <- B / rowSums(B)
# utils functions
from_B_to_laplacian <- function(B) {
  A <- from_B_to_adjacency(B)
  return(diag(rowSums(A)) - A)
}

from_B_to_adjacency <- function(B) {
  r <- nrow(B)
  q <- ncol(B)
  zeros_rxr <- matrix(0, r, r)
  zeros_qxq <- matrix(0, q, q)
  return(rbind(cbind(zeros_rxr, B), cbind(t(B), zeros_qxq)))
}
Ltrue <- from_B_to_laplacian(B)
X <- MASS::mvrnorm(100*p, rep(0, p), MASS::ginv(Ltrue))
S <- cov(X)
bipartite_graph <- learn_bipartite_graph_nie(S = S,
                                             r = r,
                                             q = q,
                                             k = 1,
                                             learning_rate = 5e-1,
                                             eta = 0,
                                             verbose=FALSE)
}
\references{
Feiping Nie, Xiaoqian Wang, Cheng Deng, Heng Huang.
            "Learning A Structured Optimal Bipartite Graph for Co-Clustering".
            Advances in Neural Information Processing Systems (NIPS 2017)
}
