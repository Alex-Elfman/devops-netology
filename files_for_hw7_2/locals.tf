locals {
  org      = "netology"
  project  = "develop"
  instance = "platform" 
 }

name = "${ local.org }-${ local.project }-${ local.instance }-web"
name = "${ local.org }-${ local.project }-${ local.instance }-db"
