# 基于openanolis龙蜥镜像来构建owllook镜像
FROM openanolis/anolisos
MAINTAINER SYS
ENV TIME_ZONE=Asia/Shanghai
ADD . /owllook
WORKDIR /owllook
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && yum install gcc gcc-c++ glibc make automake autoconf python36 python36-devel openssl openssl-devel which \
    && pip install --no-cache-dir --trusted-host mirrors.aliyun.com -i http://mirrors.aliyun.com/pypi/simple/ pipenv \
    && pipenv install --skip-lock && pipenv install pymongo \
    && find . -name "*.pyc" -delete
CMD ["pipenv", "run", "gunicorn", "-c", "owllook/config/gunicorn.py", "--worker-class", "sanic.worker.GunicornWorker", "owllook.server:app"]
