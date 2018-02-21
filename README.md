# Langton's ant walking on Voronoi tessellation

<center><img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/intro.png" alt="Bounded evolution of the ant"/></center>

**Langton-Voronoi** is a program extending the classic Langton's ant by enabling the ant to walk on any Voronoi tessellation of the plane. I strongly encourage you to read the related blog post here: https://ahstat.github.io/Langton-Voronoi/
It explains what is the Langton's ant and how the process has been extended.

**Parameters**

Many parameters can be adjusted directly in the "main.R" file. There are divided into four categories:
- Tessellation: a deldir object. A simple method to build it is to draw N points in [-0.5,0.5]×[-0.5,0.5] according to a seed; Then to copy those N points in the four directions to create the desired tiling.
- Initialization of the ant: selecting in which cell is the ant at the initial step (t=1) and at the previous step (t=0). By default: The cell c which is closest to (0,0) is selected at the initial step; The cell at the bottom of c is selected for the previous step.
- Rule of the ant: We select the rule as described in details in the blog post, such as "R L" or "S P". We also define the maximum number of iterations of the ant.
- Plotting and outputs: We define how the cells are colored; What is the size of the plots; Whether we need to output a plot at each iteration or only at the final one; In which file is saved the plot.

**Launching the ant**

All parameters have been selected, it is time to launch the ant!
We plot the background tessellation, and use function 'perform_walk' to perform the whole evolution.

**Some outputs**

Those outputs are detailed in the blog post.

*Evolution with SP rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_10_1000.png" alt="1000 iterations with SP rule" width="32%"/>

*Evolution with RL rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_11_1000.png" alt="1000 iterations with RL rule" width="32%"/>

*Evolution with SR rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_7_1000.png" alt="1000 iterations with SR rule" width="32%"/>

*Evolution with SL rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_1_1000.png" alt="1000 iterations with SL rule" width="32%"/>

*Evolution with SP rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_1.png" alt="1000 iterations with SP rule" width="32%"/>

*Evolution with RL rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_1.png" alt="1000 iterations with RL rule" width="32%"/>

*Evolution with SR rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_4.png" alt="1000 iterations with SR rule" width="32%"/>

*Evolution with SL rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_2.png" alt="1000 iterations with SL rule" width="32%"/>
