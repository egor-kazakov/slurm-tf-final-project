# Terraform проект

Проект, создающий 3 (*по умолчанию*) PVC из подготовленного образа nginx (*Packer*) и настраивающий **Application LoadBalancer**

**Назначение файлов:**
* **providers.tf** - описание провайдера *Yandex Cloud*
* **main.tf** - описание инстанс группы
* **networks.tf** - описание сети и подсетей
* **seviceaccounts.tf** - описание сервисного аккаунта (*для инстанс группы*)
* **loadbalancer.tf** - описание *Application LoadBalancer*
* **variables.tf** - описание всех переменных проекта
* **outputs.tf** - вывод адресов балансера и PVC