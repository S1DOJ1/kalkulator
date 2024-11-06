FROM alpine:3.7
RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/aquasecurity/trivy/releases/latest/download/trivy_0.34.0_Linux-64bit.deb && \
    dpkg -i trivy_0.34.0_Linux-64bit.deb && \
    rm trivy_0.34.0_Linux-64bit.deb

FROM python:3

WORKDIR /pacani

COPY APIcalc.py ./ 

COPY requirements.txt ./

RUN pip install --upgrade pip  

RUN pip install --no-cache-dir -r requirements.txt

RUN pip install --no-cache-dir bandit

RUN pip install --no-cache-dir semgrep

EXPOSE 8000

CMD ["python", "APIcalc.py"]
