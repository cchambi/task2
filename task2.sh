# Credencial Principal
GOOGLE_APPLICATION_CREDENTIALS="/tmp/dulce-palace-300.json" 

# VARIABLES REQUERIDAS
GCLOUD_PROJECT_NAME=$(cat $GOOGLE_APPLICATION_CREDENTIALS | grep project_id | cut -d\" -f 4)
TASK2_WORKDIR=$(pwd)
GCLOUD_BIN=$(which gcloud)
LOCAL_USER=$(whoami)
VM_NAME="centosjenkins001"


# AQUI SETEAMOS LA ZONA Y EL NOMBRE DEL CLUSTER/DOCKER IMAGE
GCLOUD_ZONE="us-east1-c"


# LA INFORMACION DE SALIDA
output() {
  echo "Settings : "
  echo " TASK2_WORKDIR = $TASK2_WORKDIR"
  echo " GOOGLE_APPLICATION_CREDENTIALS = $GOOGLE_APPLICATION_CREDENTIALS"
  echo " GCLOUD_BIN = $GCLOUD_BIN"
  echo " GCLOUD_ZONE = $GCLOUD_ZONE"ß
  echo " GCLOUD_PROJECT_NAME = $GCLOUD_PROJECT_NAME"
  echo " VM INSTANCE NAME = $VM_NAME"
}

# help
help() {
  echo "help ..."
  echo " Define variables:"
  echo " * GOOGLE_APPLICATION_CREDENTIALS = </tmp/auth.json>"
  echo " Connect to:"
}

# Creando la VM Centos
gke_gcloud() {
  $GCLOUD_BIN compute instances create $VM_NAME --image-family centos-8 --image-project centos-cloud
}

# check 
init() {

  test -e "$GOOGLE_APPLICATION_CREDENTIALS" || { echo "$GOOGLE_APPLICATION_CREDENTIALS" not existing;
    help
    exit 0;
  }
  test -e "$GCLOUD_BIN" || { echo gcloud is not installed;
    help
    exit 0;
  }
  
  
  # SETEAMOS LA AUTENTICACION DE LA CUENTA DE SERVICIO Y NUESTRO PROYECTO PRINCIPAL
  $GCLOUD_BIN auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
  $GCLOUD_BIN config set project $GCLOUD_PROJECT_NAME 
  echo Y | $GCLOUD_BIN services enable cloudresourcemanager.googleapis.com
  echo Y | $GCLOUD_BIN services enable cloudbuild.googleapis.com
}

# DESTRUYE LOS RECURSOS 
destroy() {
  init
  echo Y | $GCLOUD_BIN compute instances delete $VM_NAME
  
}

# Te conecta a la instancia
sshvm() {
  init
  $GCLOUD_BIN compute scp linux_jenkins.yaml $VM_NAME:/home/$LOCAL_USER
  $GCLOUD_BIN compute ssh $VM_NAME --strict-host-key-checking=no
  echo Y | sudo dnf install epel-release
  sudo dnf makecache
  echo Y | sudo dnf install ansible
  
  
  
}

# CREANDO VM
create() {
  init
  gke_gcloud # with gcloud
}

case "$1" in
  "destroy" ) echo "call destroy ..." && destroy
	  ;;
  "create" ) echo "call create ..." && create
	  ;;
  "output" ) echo "call output ..." && output
	  ;;
  "vm" ) echo "call sshvm ..." && sshvm
	  ;;
  *) echo "exit" && help 
esac
