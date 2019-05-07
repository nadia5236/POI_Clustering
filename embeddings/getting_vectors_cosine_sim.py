import numpy as np
import time
from pprint import pprint


def cos_sim(a, b):
    """Takes 2 vectors a, b and returns the cosine similarity according
    to the definition of the dot product
    """
    dot_product = np.dot(a, b)
    norm_a = np.linalg.norm(a)
    norm_b = np.linalg.norm(b)
    return dot_product / (norm_a * norm_b)

def getting_vector_cosine_sim(vector_file_01, vector_file_02):

    #Return the vectors and labels for the first n_words in vector file.
    numpy_array_01 = []
    labels_array_01 = []

    numpy_array_02 = []
    labels_array_02 = []

    # first embedding file
    with open(vector_file_01, 'r') as f:
        for c, r in enumerate(f):
            sr = r.split()

            # storing all the labels
            labels_array_01.append(sr[0])

            # storing all the vectors
            numpy_array_01.append(np.array([float(i) for i in sr[1:]]))

    labels_array_01.pop(0)
    numpy_array_01.pop(0)

    with open(vector_file_02, 'r') as f:
        for c, r in enumerate(f):
            sr = r.split()

            # storing all the labels
            labels_array_02.append(sr[0])

            # storing all the vectors
            numpy_array_02.append(np.array([float(i) for i in sr[1:]]))

    labels_array_02.pop(0)
    numpy_array_02.pop(0)

    null_dict = {}

    for i in range(len(labels_array_01)):
        null_dict.update({labels_array_01[i]: numpy_array_01[i]})

    real_dict = {}

    for i in range(len(labels_array_02)):
        real_dict.update({labels_array_02[i]: numpy_array_02[i]})

    min_label = min(labels_array_01)
    max_label = max(labels_array_01)

    i = int(min_label)
    m = int(max_label)


    f_cos_sim = open("cos_sim.csv", "w")
    f_cos_sim.write("node1,node2,null_cos_sim,real_cos_sim,diff\n")



    start = time.time()


    # two while loops only get n*(n-1) / 2 pairs out of cell nodes.
    while i < m:

        j = i + 1

        while j <= m:

            # storing node combinations and cosine similarity of null model values.
            f_cos_sim.write(str(i) + "," + str(j) + "," + str(cos_sim(null_dict[str(i)], null_dict[str(j)])) + ",")

            if (str(i) in real_dict) and (str(j) in real_dict):

                f_cos_sim.write(str(cos_sim(real_dict[str(i)], real_dict[str(j)])) + "," + str(cos_sim(real_dict[str(i)], real_dict[str(j)]) - abs(cos_sim(null_dict[str(i)], null_dict[str(j)]))) + "\n")

            else:
                f_cos_sim.write("infinite,infinite\n")

            j = j + 1

        i = i + 1

    end = time.time()

    print(end - start)



getting_vector_cosine_sim('nodes.emb', 'real_nodes.emb')

