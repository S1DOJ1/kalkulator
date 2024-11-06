FROM alpine:3.7
RUN apk add curl \
    && curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/master/contrib/install.sh | sh -s -- -b /usr/local/bin \
    && trivy filesystem --exit-code 1 --no-progress /

FROM python:3

WORKDIR /pacani

COPY APIcalc.py ./ 

COPY requirements.txt ./

RUN pip install --upgrade pip  

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir bandit

RUN pip install --no-cache-dir semgrep

#RUN pip install  --no-cache-dir trivy

EXPOSE 8000

CMD ["python", "APIcalc.py"]
