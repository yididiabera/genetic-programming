# 🧬 MeTTa Genetic Algorithm Implementation

This project implements a simple Genetic Algorithm (GA) in the MeTTa programming language, which is part of the [OpenCog Hyperon](https://github.com/opencog) ecosystem.

The goal is to evolve a population of binary-encoded individuals through selection, crossover, and mutation — mimicking the process of natural selection.

---

## 🔁 Algorithm Steps

### 1. Initialization

A population of individuals (binary strings) is randomly initialized and stored in the atomic space for further processing.

### 2. Fitness Evaluation

Each individual's fitness is calculated based on the number of `1`s in its binary representation. This helps determine how "fit" each individual is for reproduction.

### 3. Selection

A roulette wheel selection mechanism is used to probabilistically select parents. Fitter individuals have a higher chance of being selected, but less-fit individuals still have a non-zero chance, preserving diversity.

The selection steps include:

- Calculating total fitness of the population
- Generating individual selection probabilities
- Building a cumulative probability wheel
- Using a random float to select an individual based on its probability range

### 4. Crossover

Two selected parents undergo single-point crossover:

- Each parent's binary string is split into halves
- The halves are swapped to create two new offspring
- This introduces new combinations of traits into the population

### 5. Mutation

Mutation is performed on the offspring:

- A binary bit is flipped (i.e., `0 → 1`, or 1 → 0)
- This introduces randomness and helps avoid local optima
