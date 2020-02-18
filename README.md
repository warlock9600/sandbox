## Установка свежего анзибля

скриптик добавляет репу свежего анзибля и ставит пару плюшек для питона

```
sudo ./install-ansible.sh
```

## Развертывание ВМ

установить терраформ

```
wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip
sudo cp terraform /usr/local/bin
```

иницииализировать терраформ

```
terraform init
```

чекнуть план и если все ок - развернуть. в файле terraform.state будет вывод созданной инфраструктуры.

```
terraform plan
terraform apply
```

установить генератор inventory

```
wget https://github.com/adammck/terraform-inventory/releases/download/v0.9/terraform-inventory_0.9_linux_amd64.zip
unzip terraform-inventory_0.9_linux_amd64.zip
sudo cp terraform-inventory /usr/local/bin
```
сформировать инвентори

```
./inventory-create.sh
```

## Базовое развертывание ВМ

запускаем initial плейбук с указанием юзера (для прохода с помощью become root при первой прокатке)

```
ansible-playbook playbook-initial.yml -u ubuntu
```

## Установка докера и сворма

берем роль для докера из галактики
```
ansible-galaxy install atosatto.docker-swarm
```

фиксим баг с пакетом gpg

```
sed -i '7s/gpg/gpgv2/' ~/.ansible/roles/atosatto.docker-swarm/tasks/repo-Debian.yml
```

прокатываем роль с докер-свормом, и добавляем оверлей сетку со скоупом на весь сворм

```
ansible-playbook playbook-swarm.yml
ansible-playbook playbook-swarm-net.yml

```
проверяем что все ок
```
ansible yandex_vm_1 -a "docker node ls"
```

## Развертывание сервисов

прокатываем роль

```
ansible-playbook playbook-deploy.yml
```

## Проверка

если по предложению скрипта, формирующего инвентори, добавить записи в hosts, то по следующим адресам будут доступны соответствующие сервисы

http://grafana.local

http://prometheus.local

http://kibana.local