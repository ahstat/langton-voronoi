# Langton's ant walking on Voronoi tessellation

<center><img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/intro.png" alt="Bounded evolution of the ant"/></center>

**Langton-Voronoi** is a program extending the classic Langton's ant by enabling the ant to walk on any Voronoi tessellation of the plane. I strongly encourage you to read the related blog post here: https://ahstat.github.io/Langton-Voronoi/
It explains what is the Langton's ant and how the process has been extended.

**Parameters**

Many parameters can be adjusted directly in the "main.R" file. There are divided into four categories:
- Tessellation: a deldir object. A simple method to build it is to draw N points in [-0.5,0.5]×[-0.5,0.5] according to a seed; Then to copy those N points in the four directions to create the desired tiling.
- Initialization of the ant: selecting in which cell is the ant at the initial step (t=1) and at the previous step (t=0). By default: The cell c which is closest to (0,0) is selected at the initial step; The cell at the bottom of c is selected for the previous step.
- Rule of the ant: We select the rule as described in details in the blog post, such as "R L" or "S P". We also define the maximum number of iterations of the ant.
- Plotting and outputs: We define how the cell are colored; What is the size of the output; Whether we need to output a plot at each iteration or only for the last one; In which file the output is saved. 

**Launching the ant**

All parameters have been selected, it is time to launch the ant!
We plot the background tessellation, and use function 'perform_walk' to perform the whole evolution.

**Some outputs**

Those outputs are detailed in the blog post.

*Evolution with SP rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_10_1000.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_11_1000.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_23_1000.png" alt="1000 iterations with SP rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_67_1000.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_57_1000.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_70_390.png" alt="1000 iterations with SP rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_94_1000.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_88_1000.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SP/5000_seed_80_1000.png" alt="1000 iterations with SP rule" width="32%"/>

*Evolution with RL rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_11_1000.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_12_1000.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_23_1000.png" alt="1000 iterations with RL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_66_1000.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_100_1000.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_67_1000.png" alt="1000 iterations with RL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_69_1000.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_72_1000.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/RL/5000_seed_81_1000.png" alt="1000 iterations with RL rule" width="32%"/>

*Evolution with SR rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_7_1000.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_14_1000.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_27_1000.png" alt="1000 iterations with SR rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_33_1000.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_57_1000.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_83_1000.png" alt="1000 iterations with SR rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_84_1000.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_38_1000.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SR/5000_seed_96_1000.png" alt="1000 iterations with SR rule" width="32%"/>

*Evolution with SL rule*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_1_1000.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_2_1000.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_3_1000.png" alt="1000 iterations with SL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_10_1000.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_14_1000.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_23_1000.png" alt="1000 iterations with SL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_72_1000.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_94_1000.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/SL/5000_seed_95_1000.png" alt="1000 iterations with SL rule" width="32%"/>

*Evolution with SP rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_1.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_8.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_12.png" alt="1000 iterations with SP rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_25.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/12_seed_4.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_38.png" alt="1000 iterations with SP rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_74.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_76.png" alt="1000 iterations with SP rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SP/11_seed_81.png" alt="1000 iterations with SP rule" width="32%"/>

*Evolution with RL rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_1.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_2.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_3.png" alt="1000 iterations with RL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_4.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_99.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_5.png" alt="1000 iterations with RL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_91.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_85.png" alt="1000 iterations with RL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_RL/11_seed_72.png" alt="1000 iterations with RL rule" width="32%"/>

*Evolution with SR rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_4.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_19.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_20.png" alt="1000 iterations with SR rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_66.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_54.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_88.png" alt="1000 iterations with SR rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_93.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_67.png" alt="1000 iterations with SR rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SR/11_seed_73.png" alt="1000 iterations with SR rule" width="32%"/>

*Evolution with SL rule and a translated tesselation*

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_2.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_24.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_41.png" alt="1000 iterations with SL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_39.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_36.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_49.png" alt="1000 iterations with SL rule" width="32%"/>

<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_96.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_89.png" alt="1000 iterations with SL rule" width="32%"/>
<img src="https://ahstat.github.io/images/2016-12-11-Langton-Voronoi/translated_SL/11_seed_98.png" alt="1000 iterations with SL rule" width="32%"/>

