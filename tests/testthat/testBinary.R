data("demoBinary")
fixedIcepFit <- gppm('Icep','sigma*(t==t#)',demoBinary,'ID','y',family = 1)
fixedIcepFit <- fit(fixedIcepFit,verbose=TRUE)
