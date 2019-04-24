import numpy as np
from statistics import mean
import matplotlib.pyplot as plt
from sklearn.manifold import TSNE

def tsne_plot(vectors, label):
    "Creates and TSNE model and plots it"
    labels = label
    tokens = vectors
    
    tsne_model = TSNE(perplexity=40, n_components=2, init='pca', n_iter=1000, random_state=23)
    new_values = tsne_model.fit_transform(tokens)

    x = []
    y = []
    for value in new_values:
        x.append(value[0])
        y.append(value[1])
        
    plt.figure(figsize=(16, 16)) 
    for i in range(len(x)):
        plt.scatter(x[i],y[i])
        plt.annotate(labels[i],
                     xy=(x[i], y[i]),
                     xytext=(5, 2),
                     textcoords='offset points',
                     ha='right',
                     va='bottom')
    plt.show()


def build_word_vector_matrix(vector_file, n_words):
    #Return the vectors and labels for the first n_words in vector file
    numpy_arrays = []
    labels_array = []
    with open(vector_file, 'r') as f:
        for c, r in enumerate(f):
            sr = r.split()

            labels_array.append(sr[0])
            numpy_arrays.append(np.array([float(i) for i in sr[1:]]))
            if c == n_words:
                return np.array(numpy_arrays[1:]), np.array(labels_array[1:])
    return np.array(numpy_arrays[1:]), np.array(labels_array[1:])


tsne_plot(*build_word_vector_matrix('real_nodes.emb', 25))