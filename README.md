# Actualización-subsistemas

Este procedimiento se realiza en el servidor central Colombia 

Se instalan los siguientes componentes con el fin de crear un motor que permita mantener actualizados los subsistemas en los diferentes ecosistemas xroad que interactúan entre sí.

El bash que se ejecuta realiza las siguientes funciones:
- inserta la llave privada AND_private.key
- inserta el certificado de autofirmado AND_certificate.crt
- inserta componte que realiza todo el proceso de actualización
- se instala última versión de ruby
- edita el cron de xroad center-service y programa la ejecución de este servicio
 
./install.sh


NOTA: Es importante tener en cuenta que para una correcta federación se debe editar el archivo /etc/xroad/conf.d/local.ini en el servidor de seguridad de la siguiente forma:

[configuration-client]
allowed-federations=all
