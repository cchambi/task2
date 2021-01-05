# TASK2

# Pre-requisitos del S.O

  - Google SDK
  - Activar los siguientes API en GCP ( Compute Engine , Kubernetes Engine )
  - Ansible 2.7.1 o superior

# Primero, modificamos el nombre de la Instancia de compute engine a crear, en el archivo task2.sh

    VM_NAME="centosjenkins001"
    
# Parametros

    sh TASK2.sh output     =>  nos brinda informacion relevante para el proyecto
    sh TASK2.sh create     =>  crea los recursos necesarios para la instancia
    sh TASK2.sh destroy    =>  purga todos los recursos creados   
