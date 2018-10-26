#!/bin/bash
# If your Solus installation or Live USB is out of date you may have noticed that you are unable to install/update from the original repo. This is due to a URL change from 'solus-project.com' to 'getsol.us'.
# The below script will direct eopkg to the most recent repo (as of 11/2018)
# https://getsol.us/2018/09/11/package-repo-migration-now-available/




sudo eopkg dr Solus
sudo eopkg rr Solus
sudo eopkg ar Solus https://mirrors.rit.edu/solus/packages/shannon/eopkg-index.xml.xz



