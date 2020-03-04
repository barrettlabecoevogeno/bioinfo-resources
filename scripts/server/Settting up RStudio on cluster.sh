########################################################################
# Using RStudio on the Server 
# Source: https://docs.computecanada.ca/wiki/Jupyter/fr 
########################################################################

# Go on the server and connect to it: 
ssh beluga.computecanada.ca -l USERNAME

# Load the Python module
module load python/3.6

# Create a new Python virtual environment.
virtualenv $HOME/jupyter_py3

# Activate your newly created Python virtual environment
source $HOME/jupyter_py3/bin/activate

# Install Jupyter Notebook in your new virtual environment 
pip install jupyter

# In the virtual environment, create a wrapper script that launches Jupyter Notebook
echo -e '#!/bin/bash\nunset XDG_RUNTIME_DIR\njupyter notebook --ip $(hostname -f) --no-browser' > $VIRTUAL_ENV/bin/notebook.sh

# Finally, make the script executable
chmod u+x $VIRTUAL_ENV/bin/notebook.sh

### RStudio Launcher
pip install nbserverproxy
pip install https://github.com/jupyterhub/nbrsessionproxy/archive/v0.8.0.zip
jupyter serverextension enable --py nbserverproxy --sys-prefix
jupyter nbextension install --py nbrsessionproxy --sys-prefix
jupyter nbextension enable --py nbrsessionproxy --sys-prefix
jupyter serverextension enable --py nbrsessionproxy --sys-prefix

# Activate the environment 
module load python/3.6
source $HOME/jupyter_py3/bin/activate

# RStudio Server
# module spider rstudio-server
# module spider rstudio-server/1.2.1335
module load nixpkgs/16.09  gcc/7.3.0 rstudio-server

# Starting Jupyter Notebook
salloc --time=1:0:0 --ntasks=1 --cpus-per-task=2 --mem-per-cpu=1024M --account=def-barrett srun $VIRTUAL_ENV/bin/notebook.sh
# There will be a link. Copy that. 


########################################################################
# In YOUR computer terminal 
########################################################################
# Make sure sshuttle is installed:
brew install sshuttle
sshuttle --dns -Nr mobze@beluga.computecanada.ca

# GO on a browser and paste the link that was copied into it. 
# Go to new, and then "RStudio Session"
########################################################################

## Once your are done with the environment, you can deactivate it with this: 
deactivate


########################################################################
# To reload a notebook, do this: 
source $HOME/jupyter_py3/bin/activate
salloc --time=1:0:0 --ntasks=1 --cpus-per-task=2 --mem-per-cpu=1024M --account=def-barrett srun $VIRTUAL_ENV/bin/notebook.sh
########################################################################
# In YOUR computer terminal 
sshuttle --dns -Nr mobze@beluga.computecanada.ca
########################################################################