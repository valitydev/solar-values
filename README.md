Helm Charts Repo
=========

В этом репозитории находятся переменные для деплоя платформы RBK.money. Структура каталога следующая:

- charts - чарты вспомогательных сервисов
- config - настройки чартов, по каталогу на сервис



Требования
----------

Для деплоя процессинга требуется:
 - Helm 3.2.1+
 - [Helmfile](https://github.com/roboll/helmfile)
 - kubectl
 - Пара key+cert для wildcard домена процессинга *.%domain.name%


Деплой
----------
  
> Перед деплоем необходимо присвоить неймспейсу, в который осуществляется деплой, лейбл vaultname=%ns_name%. 
> например, для default неймспейса необходимо выполнить команду `kubectl label ns default vaultname=default`

1. Создать секрет для tls (имя `solarweb` используется в скриптах, поэтому если используется другое имя секрета, необходимо изменить его в файле `default.values.yaml`):
```
kubectl create secret tls solarweb --key PATH_TO_KEY --cert PATH_TO_CERT
```
`PATH_TO_KEY` - путь к pem файлу ключа  
`PATH_TO_CERT` - путь к pem файлу сертификата  

2. Если используется домен, отличный от proc.loc, необходимо изменить его в файле default.values.yaml в строках:
    externalUrl: "https://auth.proc.loc:31337"  
    rootDomain: proc.loc
3. Установка платформы:
```
helmfile sync
```
4. Expose необходимых сервисов:
```
kubectl create -f nodeport.yaml
```
5. Прописать в конфигурацию магазина drupal, настройка осуществляется по адресу /admin/store/settings/rbkmoney, admin:admin, Приватный ключ, полученый командой:
```
curl -d "client_id=$KC_CLIENT_ID" -d "username=$KC_USERNAME" -d "password=$KC_PASSWORD" -d 'grant_type=password' 'https://auth.proc.loc:31337/auth/realms/external/protocol/openid-connect/token' | jq -r '.access_token'
```



Доступ к логам в kibana
-----------
[docs reference](https://www.elastic.co/guide/en/cloud-on-k8s/current/k8s-deploy-kibana.html)
our name is "rbkmoney" not "quickstart"

Use kubectl port-forward to access Kibana from your local workstation:

```
kubectl port-forward service/rbkmoney-kb-http 5601
```
and go to `https://localhost:5601`.
OR
Open https://kibana.proc.loc:30601 in your browser. 

Login `elastic`. Пароль можно получить следующей командой:

```
kubectl get secret -n monitoring rbkmoney-es-elastic-user -o=jsonpath='{.data.elastic}' | base64 --decode; echo
```

