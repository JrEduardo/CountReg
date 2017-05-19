#-----------------------------------------------------------------------
# Ckeck & Build.

library(devtools)

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

#-----------------------------------------------------------------------

# Install dependencies.
system('sudo Rscript -e\\
       "library(devtools);\\
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

# Transfere as vinhetas.
cmd <- paste("scp -P 4922",
             paste(dir(path = "inst/doc",
                       pattern = "*.html",
                       full.names = TRUE), collapse = " "),
             "walmes@200.17.213.49:~/public_html/pacotes/EACS-vignettes")
system(cmd)

# IP address and port (you can define these credential in .Rprofile).
credent <- scan(n = 2, what = "character")

cmd <- sprintf(paste("rsync -avzp ./docs --progress",
                     '--rsh="ssh -p%s"',
                     '"%s:~/public_html/pacotes/gammacount"'),
               credent[2], credent[1])

cat(cmd)

system(cmd)

#-----------------------------------------------------------------------
