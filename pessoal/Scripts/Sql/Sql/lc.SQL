select (1-(sum(reloads)/sum(pins)))*100 Hit from v$librarycache
/
