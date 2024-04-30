# Databases 3 final assignment repository

This repository is the final hand in for a databases 3 assignment in which a quote database is implemented.
The database stores information about customers and suppliers, and which items they buy and sell as components.
Components can be assemblies which hold components or other assemblies, and to sanity check this the scripts include functionality to check if an assembly is cyclic;
That is, it holds another copy of itself, which clearly isn't possible in any real world scenario.
