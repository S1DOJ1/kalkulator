# kalkulator
## РИ-411001: 
 ( Мурин С. ,
  Кравцов Е. ,
  Курылев м. ,
  Кубышко с. ,
  Дмитрий м.)

  # 1)Написание API-калькулятора и запуск в докер контейнере
  -APIcalc.py - сам калькулятор
  
  Установили докер на ubuntu 24.04

  Создали Dockerfile для сборки образа контейнера
  
  А затем собрали докер-образ:
  
  ![image](https://github.com/user-attachments/assets/3bf46d55-4948-4746-830e-147bff969eb0)

  Все работает:

  ![image](https://github.com/user-attachments/assets/5509abaa-a61d-4e97-87de-7736d0d0219e)

  # 2)Создание пайплайна для обновления версии калькулятора

  Настроили систему контроля версий git

  Настроили Jenkins для непрерывной интеграции, который автоматически обновляет верси калькулятора при каждом пуше кода

    triggers { pollSCM('* * * * *') }

  ![image](https://github.com/user-attachments/assets/2debef51-eb1b-43b6-8a34-53a4a887257b)

  # 3)Внедрение открытых инструментов безопасности в пайплайн

Дописали Dockerfile и jankinsefile для того чтобы при каждой новой сборке докер образа после обновления кода он автоматически сканировал его на наличие уязвимостей.

  TRIVY:

  Изменения Dockerfile:
  
    FROM alpine:3.7
    RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.34.0_Linux-64bit.deb && \
    dpkg -i trivy_0.34.0_Linux-64bit.deb && \
    rm trivy_0.34.0_Linux-64bit.deb

  Изменения jankinsefile
  
    sh 'trivy image --severity HIGH test:latest'

  Semgrep:

  Изменения Dockerfile:

    RUN pip install --no-cache-dir semgrep

  Изменения jankinsefile:
    
	stage('semgrep') {
	    steps {
	    	sh 'docker run --rm test:latest semgrep --config auto '
	    }	
  Bandit:
  
  Изменения Dockerfile:

    RUN pip install --no-cache-dir bandit
  
  Изменения jankinsefile:
  
    stage('bandit') {
	    steps {
		    sh 'sleep 10'
		    sh 'docker run --rm test:latest bandit -r . -lll'
	        }
	    }
# 4)Анализ работы инструментов безопасности
  Результат работы bandit:

  ![image](https://github.com/user-attachments/assets/1dad7707-b446-4c5c-a9e1-a5511d883a7f)

  Результат работы semgrep:

  ![image](https://github.com/user-attachments/assets/5961804e-5b20-40f1-b7e2-07c25cfac156)

  ![image](https://github.com/user-attachments/assets/b7b56247-9438-4c4e-9372-b5da96741a24)

  Резлультат работы trivy:
  
  ![image](https://github.com/user-attachments/assets/399f9b60-c0d0-45cf-bfa8-63d07a6ff16b)

 -Semgrep указал на то, что хостом приложения служит 0.0.0.0 и это является ошибкой, для исправления которой, достаточно поменять хост с 0.0.0.0 например на 172.17.0.2
 
 -Большинство уязвимостей найденых trivy являются старые версии пакетов приложений, чтобы  это исправить достаточно их просто обновить.



  


    


  


    



