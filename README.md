# Практикум по курсу Terraform

Задание описано в [wiki](https://github.com/egor-kazakov/slurm-tf-final-project/wiki)

## Необходимые дистрибутивы

 Для работы необходимо:
 1. Yandex Cloud CLI
 1. Terraform
 1. Packer

 Для установки **Yandex Cloud CLI** воспользуйтесь командой (согласно [инструкции](https://cloud.yandex.ru/docs/cli/quickstart#install)):
 ```
 curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
 ```

Инструкция по установке [**Terraform**](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#install-terraform)

Инструкция по установке [**Packer**](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/packer-quickstart#install-packer)

> *Зеркала на территории РФ недоступны (11.06.2023). Используйте VPN*

## Настройка доступа к облаку

**Примчание:** в данном проекте не храняться токены. Все авторизационные данные необходимо объявить в *Environment Variables*.

Необходимо сначала проинициализировать **Yandex Cloud CLI** ([инструкция](https://cloud.yandex.ru/docs/cli/quickstart#initialize)):
```
yc init
```

После инициализации **Yandex Cloud CLI** экспортируйте переменные:
```
export YC_TOKEN=$(yc config get token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_ZONE="ru-central1-a"
export YC_SUBNET_ID="$(yc vpc subnet show default-ru-central1-a | head -1 | awk '{ print $2 })'"

# Фикс folder_id
export TF_VAR_YC_FOLDER_ID=$YC_FOLDER_ID
```

> При необходимости параметры **YC_ZONE** и **YC_SUBNET_ID** можно посмотреть командой: `yc vpc subnet list`.
> Запишите идентификатор подсети (столбец **ID**), в которой будет размещаться вспомогательная ВМ, на основе которой создается образ, а также соответствующую зону доступности (столбец **ZONE**). Эти параметры потребуются для **Packer**.

## Подготовка образа (Packer)

В командной строке перейдите в папку с конфигурационным файлом образа:
```
cd packer
```

Проинициализируйте **Packer**:
```
packer init .
```

Проверьте корректность конфигурационного файла образа с помощью команды:
```
packer validate .
```

Если конфигурация является корректной, появится сообщение:
```
The configuration is valid.
```

Запустите сборку образа с помощью команды (**версия потребуется позднее**):
```
packer build -var 'image_tag=1' .
```

После завершения сборки будет выведено сообщение о том, что образ успешно создан.

## Применение конфигурации

Перейдите в директорию **Terraform**:
```
cd terraform
```

Проинициализируйте проект **Terraform**:
```
terraform init
```

Примените конфигурацию:
```
terraform apply
```
> Используйте **-var** или **-var-file** чтобы изменить параметры

## Удаление проекта
> В связи с тем, что это тестовый стенд с конечным граном (3000 руб. + 1000 руб.), рекомендуется удаление стенда.
Удалите созданную инфраструктуру:
```
terraform destroy
```

Удалите образы, созданные *Packer*:
```
yc compute image delete nginx-1
```