# Практикум по курсу Terraform

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
export YC_ZONE="<зона_доступности>"
export YC_SUBNET_ID="<идентификатор_подсети>"

```

> Параметры **YC_ZONE** и **YC_SUBNET_ID** можно посмотреть командой: `yc vpc subnet list`.
> Запишите идентификатор подсети (столбец **ID**), в которой будет размещаться вспомогательная ВМ, на основе которой создается образ, а также соответствующую зону доступности (столбец **ZONE**). Эти параметры потребуются для **Packer**.

## Подготовка образа (Packer)

В командной строке перейдите в папку с конфигурационным файлом образа:
```
cd packer
```

Проинициализируйте **Packer**:
```
packer init config.pkr.hcl
```

Проверьте корректность конфигурационного файла образа с помощью команды:
```
packer validate nginx.pkr.hcl
```

Если конфигурация является корректной, появится сообщение:
```
The configuration is valid.
```

Запустите сборку образа с помощью команды (**версия потребуется позднее**):
```
packer build nginx.pkr.hcl -var 'image_tag=1'
```

После завершения сборки будет выведено сообщение о том, что образ успешно создан.