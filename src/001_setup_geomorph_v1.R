### Setup project folders and set root dir

# Set project specific subfolders
cat("#--- set Folders ---#",sep = "\n")
project_folders = c("data/",                                
                    "data/001_org/",
                    "data/002_processed/",
                    "data/003_Stage_2/",
                    "data/004_Stage_3/",  #local data not in repo
                    "tmp/", # tmp folder for saga data
                    "GIS/",
                    "repo/src/",   #for scripts
                    "repo/doc/",   #for docs
                    "repo/lit/",   #for literature
                      
                    
                    "repo/src/Cenith_V2/",
                    "repo/src/000_dev/"
                   
                    
)

# Automatically set root direcory, folder structure and load libraries
cat("#--- set up Environment  ---#",sep = "\n")
envrmt = createEnvi(root_folder = "~/edu/Envimaster-Geomorph/", 
                    folders = project_folders, 
                    path_prefix = "path_", libs = libs,
                    alt_env_id = "COMPUTERNAME", alt_env_value = "PCRZP",
                    alt_env_root_folder = "F:/edu/Envimaster-Geomorph/")

cat("#--- use '(file.path(envrmt$...) to set path to folderstructure ---#",sep = "\n")
# set temp directory for raster package


rm(libs)
cat(" ",sep = "\n")
cat(" ",sep = "\n")
cat(" ",sep = "\n")


cat("EEEE n   n v       v rrrr    m     m   ttttt ",sep = "\n")
cat("E    nn  n  v     v  r   r  m m   m m    t   ",sep = "\n")
cat("EE   n n n   v   v   rrrr   m m   m m    t   ",sep = "\n")
cat("E    n  nn    v v    r  r  m   m m   m   t   ",sep = "\n")
cat("EEEE n   n     v     r   r m    m    m   t   ",sep = "\n")
cat("                         for Geomorph ready",sep = "\n")

