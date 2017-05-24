#-----------------------------------------------------------------------
# Ckeck & Build.

library(devtools)

# Delete to recreate files.
system("git clean -xf ./src")

load_all()
packageVersion("gammacount")
ls("package:gammacount")

citation("gammacount")

document()
check_man()

system("find . -name '.#*' -delete")
check(manual = TRUE, vignettes = FALSE, check_dir = ".")

build(vignettes = FALSE, manual = TRUE, path = "./docs")

#-----------------------------------------------------------------------
# Package documentation with pkgdown.

library(pkgdown)

build_site()
build_home()

#-----------------------------------------------------------------------

# Install dependencies.
system('sudo Rscript -e\\
       "library(devtools);\\
        .libPaths(\\"/usr/lib/R/site-library\\");\\
        load_all();\\
        install_deps()"')

# Install package.
system('sudo Rscript -e\\
       "library(devtools);\\
        load_all();\\
        .libPaths(\\"/usr/lib/R/site-library\\");\\
        install(build_vignettes = FALSE,\\
                dependencies = FALSE,\\
                upgrade_dependencies = FALSE)"')

#-----------------------------------------------------------------------
# SCP transfer.

# IP address and port (you can define these credential in .Rprofile).
credent <- scan(n = 2, what = "character")

cmd <- sprintf(paste("rsync -avzp ./docs --progress",
                     '--rsh="ssh -p%s"',
                     '"%s:~/public_html/pacotes/gammacount"'),
               credent[2],
               credent[1])

cat(cmd)

system(cmd)

#-----------------------------------------------------------------------
# https://stackoverflow.com/questions/42313373/.

# Updates the *_init.c file.
sink(file = "./src/gammacount_init.c")
tools::package_native_routine_registration_skeleton(".")
sink()

#-----------------------------------------------------------------------
