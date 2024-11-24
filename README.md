This is EvoCamo. by luk3jb on GitHub.
made with Processing 4.

in theory, this evolution simulator should result in creatures mimicing their environment. so far, ive seen the predators learn to identify and catch prey, but I havent been able to observe any camouflage patterns.
either I havent left the simulation on for long enough (35 hours), or the settings aren't optimal. or theres a glaring issue with my code that results in the game progressing drastically different than how it was supposed to. its terribly optimised so the fastforward feature doesnt really work.
another issue that im still trying to wrap my head around is a strange phenomenon where the preys start eating constantly and dying whenever they fail to eat, leading to their average lifespan being only a few frames. I cant figure out why this happens because the reward for eating is a longer lifespan, and the reward for having a longer lifespan, is a longer time period for their genes to be copied when another dies.

Anyways I still found this really interesting and I think its pretty good for my first stab at an evolution simulator. if you happen to find this, feedback is appreciated.

ChatGPT helped me code the neural network.


Rules of EvoCamo:

there are 2 types of creatures: predators and preys.
both predators and preys can see a 16x16 image of whats below them.
those imputs and their age in frames are fed into their neural networks.
both predators and preys can move in 4 directions. determined by the output of their neural networks.
predators can see the patterns of prey, and the ground. prey can see the ground, and cannot see predators.
predators have a set lifespan. the default its set to is 250-500 frames.
predators can increase their lifespan by eating prey. they have a 5th neural net output that decides when they do.
if predators eat, and their centre 4 pixels of their vision (the red dot) is above a prey, they have successfully eaten.
if the dot is not over a prey, they die instantly.
preys die when predators eat them.
when predators or preys die, a new one spawns near a living one, and their brain is copied from their parent with some small mutations.
a prey's pattern is copied from their parents with small mutions.
preys can't overlap eachother.
