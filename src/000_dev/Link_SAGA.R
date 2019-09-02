# LinkSaga

cat("###--- searching for SAGA version (this could take a while) ---###", sep = "\n")
cat("#- Search SAGA versions -#", sep = "\n")
find_SAGA <- link2GI::findSAGA()
cat("This SAGA versions were found:", sep = "\n")
print(find_SAGA$binDir)
chosen_version <- as.numeric(readline(prompt = "Chose your preferred version number (the one in [brackets]) (6.2)  ->  "))
cat("#- Create SAGA environment -#", sep = "\n")
SAGAenv <- RSAGA::rsaga.env(path = file.path(find_SAGA$binDir[chosen_version]))
cat("#- SAGA-Environment created -#", sep = "\n")
cat("!!!- Note: Set a variable 'env = SAGAenv' to every RSAGA function you execute, so your preferred SAGA version is used -!!!")
rm(chosen_version)
##############################################################################################
##############################################################################################